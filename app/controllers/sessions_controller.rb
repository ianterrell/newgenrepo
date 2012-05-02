class SessionsController < ApplicationController
  def new
  end

  def create
    user = V1::User.from_omniauth(request.env["omniauth.auth"])
    session[:omniauth_hash] = request.env["omniauth.auth"]
    # TODO: Strip attributes this user shouldn't see
    render :json => user
  end

  def destroy
    session[:omniauth_hash] = nil
    render :json => 'ok'
  end

  def failure
    redirect_to new_session_path, notice: "Authentication failed"
  end
end