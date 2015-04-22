class UsersController < ApplicationController
  before_action :set_user, only:[:update,:destroy,:show,:edit]

  def index
    @q = params[:q]
    @users = User.search_for(params[:q]).paginate(page:params[:page])
  end

  def new
    @user = User.new
  end

  def create

  end

  def show

  end

  def edit

  end

  def update

  end

  def destroy

  end

  protected
  def user_params
    params.require(:user).permit(:id,:email,:name,:user_name,:password,:password_confirmation)
  end

  def set_user
    @user = User.find_by_id(params[:id])
  end
end
