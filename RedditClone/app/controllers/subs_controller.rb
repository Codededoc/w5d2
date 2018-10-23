class SubsController < ApplicationController

  before_action :ensure_log_in

  def new
    @sub = Sub.new
  end

  def create
    @sub = Sub.new(sub_params)
    @sub.user_id = current_user.id
    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def show
    @sub = Sub.find(params[:id])
    @posts = Post.where(sub_id: @sub.id)
    render :show
  end

  def index
    @subs_not_from_user = Sub.where.not(user_id: current_user.id)
    @subs_from_user = Sub.where(user_id: current_user.id)
  end

  def edit
    @sub = Sub.find(params[:id])
  end

  def update
    @sub = current_user.subs.find(params[:id])

    if @sub.update(sub_params)
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end
  end

  def destroy
    @sub = current_user.subs.find(params[:id])
    @sub.destroy
    redirect_to subs_url
  end

  def sub_params
    params.require(:sub).permit(:title, :description)
  end

end
