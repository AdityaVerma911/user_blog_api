require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :request do
  let(:user) { FactoryBot.create(:user, email: 'test@example.com', password: 'Password@123') }

  describe 'POST /api/v1/login' do
    it 'logs in a user with valid credentials' do
      post '/api/v1/login', params: { email: user.email, password: 'Password@123' }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['user']['email']).to eq(user.email)
      expect(session[:user_id]).to eq(user.id)
    end

    it 'returns unauthorized for invalid email' do
      post '/api/v1/login', params: { email: 'wrong@example.com', password: 'Password@123' }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized for invalid password' do
      post '/api/v1/login', params: { email: user.email, password: 'wrongpassword' }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'DELETE /api/v1/logout' do
    it 'logs out a user' do
      # First login
      post '/api/v1/login', params: { email: user.email, password: 'Password@123' }
      expect(session[:user_id]).to eq(user.id)

      # Then logout
      delete '/api/v1/logout'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('Logged out successfully')
      expect(session[:user_id]).to be_nil
    end

    it 'returns ok even when not logged in' do
      delete '/api/v1/logout'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('Logged out successfully')
    end
  end
end