class SessionsController < ApplicationController
  def create
    sign_in_from_omniauth request.env['omniauth.auth']
    redirect_to root_path
  end
end
