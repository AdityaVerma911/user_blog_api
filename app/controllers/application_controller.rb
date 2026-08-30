class ApplicationController < ActionController::API
  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def authenticate_user!
    render json: { errors: "Unauthorized" }, status: :unauthorized unless current_user
  end
end
