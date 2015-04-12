class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, only: Proc.new {|c| c.request.format.json?}
  include ApplicationHelper

  before_filter :set_model


  def set_model
    @model=self.class.name.gsub(/Controller/, '').tableize.singularize
  end

  def model
    self.class.name.gsub(/Controller/, '').classify.constantize
  end

end
