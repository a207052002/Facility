class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  def login
    redirect_to('/auth/ncu_portal_open_id')
  end

  def logout
    reset_session
    session.delete :user_id
    redirect_to '/facilities', notice: 'out'
  end

  def create
    User.find_or_create_by(portal_id: portal_id)
    session['user_id'] = portal_id
    $stderr.puts request.env['omniauth.auth'].info['user_roles']
    redirect_to('/facilities')
  end

  helper ApplicationHelper


  private

  def portal_id
    reset_session
    request.env['omniauth.auth'].uid[/\/([^\/]*)$/, 1]
  end

end
