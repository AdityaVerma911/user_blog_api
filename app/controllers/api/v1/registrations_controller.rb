class Api::V1::RegistrationsController < ApplicationController
  # POST /api/v1/signup
  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      render json: { user: { id: user.id, email: user.email } }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end