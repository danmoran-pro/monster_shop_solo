class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    session[:user_id] = user.id
    flash[:success] = "Welcome, #{user.name}, you are logged in!"
    redirect_to '/profile'
  end

end
