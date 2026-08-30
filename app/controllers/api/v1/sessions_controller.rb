class Api::V1::SessionsController < ApplicationController
  # POST /login
  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      render json: { user: { id: user.id, email: user.email } }, status: :ok
    else
      render json: { errors: "Invalid email or password" }, status: :unauthorized
    end
  end

  # DELETE /logout
  def destroy
    session[:user_id] = nil
    render json: { message: 'Logged out successfully' }, status: :ok
  end
end