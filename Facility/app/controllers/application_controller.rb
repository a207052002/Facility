class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  def current_user
    @session = session[:user_id]
  end
  include ApplicationHelper
end
