require 'rails_helper'

RSpec.describe Api::V1::RegistrationsController, type: :controller do
  describe 'POST #create' do
    let(:valid_params) {
      {
        user: {
          email: 'test@example.com',
          password: 'Password@123',
          password_confirmation: 'Password@123'
        }
      }
    }

    let(:invalid_params) {
      {
        user: {
          email: 'invalid-email',
          password: 'short',
          password_confirmation: 'mismatch'
        }
      }
    }

    let(:duplicate_params) {
      {
        user: {
          email: 'existing@example.com',
          password: 'Password@123',
          password_confirmation: 'Password@123'
        }
      }
    }

    before do
      FactoryBot.create(:user, email: 'existing@example.com')
    end

    it 'creates a new user with valid parameters' do
      expect {
        post :create, params: valid_params
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['user']['email']).to eq('test@example.com')
      expect(session[:user_id]).not_to be_nil
    end

    it 'returns errors with invalid parameters' do
      expect {
        post :create, params: invalid_params
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns error for duplicate email' do
      expect {
        post :create, params: duplicate_params
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end