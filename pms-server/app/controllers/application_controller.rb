class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :null_session, only: Proc.new {|c| c.request.format.json?}
  include ApplicationHelper

  before_filter :set_model
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!

  layout :layout_by_resource

  def set_model
    @model=self.class.name.gsub(/Controller/, '').tableize.singularize
  end

  def model
    self.class.name.gsub(/Controller/, '').classify.constantize
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  protected

  def layout_by_resource
    if devise_controller?
      "no_authorization"
      #"application"
    else
      "application"
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :user_no
  end

  private
  def authenticate_user_from_token!
    # Need to pass email and token every request
    user_email = params[:user_email].presence
    user = user_email && User.find_by_email(user_email)

    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
      sign_in user, store: false
    end
  end

end
