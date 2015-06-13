#encoding:utf-8
class UserRegistrationsController<Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, :only => [:create]

  def create
    build_resource(params.require(:user).permit(:id, :email, :name, :user_name,:nr, :password, :password_confirmation))
    respond_to do |format|
      if resource.save
        resource.add_role params[:role]
        format.html { redirect_to users_path, notice: 'User was successfully created.' }
        format.json { render :show, statue: :created, location: resource }
      else
        format.html { render :new }
        format.json { render json: resource.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    msg=Message.new
    @user=User.find_by_id(params[:id])
    if params[:user][:password].blank?
      params[:user].except!(:password)
    else
      params[:user][:password_confirmation]=params[:user][:password]
    end
    if @user.update_attributes(params[:user])
      msg.result=true
      msg.object = @user
    else
      msg.result=false
      msg.content=@user.errors
    end
    render :json => msg
  end

  protected

  def require_no_authentication
    if current_user && current_user.admin?
      return true
    else
      return super
    end
  end
end