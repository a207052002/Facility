class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  def current_user
    @session = session[:user_id]
  end
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
  include ApplicationHelper
end
