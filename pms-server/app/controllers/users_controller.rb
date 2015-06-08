class UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy, :show, :edit]

  def index
    @q = params[:q]
    @users = User.search_for(params[:q]).paginate(page: params[:page])
  end

  def new
    @user = User.new
    # authorize(@user)
  end

  def create
    @user = User.create(user_params)
    # authorize(@user)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, statue: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  protected
  def user_params
    params.require(:user).permit(:id, :email, :name, :user_name,:nr, :password, :password_confirmation)
  end

  def set_user
    @user = User.find_by_id(params[:id])
    # authorize(@user)
  end
end
