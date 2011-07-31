class ApplicationController < ActionController::Base
  include SentientController
  before_filter do |controller|
    reset_return_to_state_management(controller)
  end
  before_filter :authenticate_user!
  protect_from_forgery
  layout 'application'
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:notice] = "Access denied!"
    redirect_to :back
  end
  
  def reset_return_to_state_management(controller)
    unless ((controller.controller_name == 'folders' && (controller.action_name == 'create' || controller.action_name == 'new')) ||
        (controller.controller_name == 'states' && controller.action_name == 'create'))
      session[:return_to_state_management] = false
    end
  end
end