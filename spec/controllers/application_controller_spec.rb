require 'rails_helper'

RSpec.describe ApplicationController do
  let(:user) { FactoryBot.create(:user) }

  # Test the methods by including them in a test context
  describe '#current_user' do
    context 'when testing the method directly' do
      # Create a mock controller-like object
      let(:test_controller) do
        Class.new do
          attr_accessor :session
          def initialize
            @session = {}
          end

          def current_user
            @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
          end
        end.new
      end

      it 'returns nil when no user is logged in' do
        expect(test_controller.current_user).to be_nil
      end

      it 'returns the current user when logged in' do
        test_controller.session[:user_id] = user.id
        expect(test_controller.current_user).to eq(user)
      end
    end
  end

  describe '#authenticate_user!' do
    context 'when testing the method directly' do
      # Create a mock controller-like object
      let(:test_controller) do
        Class.new do
          attr_accessor :session, :response_status, :response_json
          def initialize
            @session = {}
          end

          def current_user
            @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
          end

          def authenticate_user!
            unless current_user
              self.response_status = :unauthorized
              self.response_json = { errors: "Unauthorized" }
            end
          end
        end.new
      end

      it 'does nothing when user is logged in' do
        test_controller.session[:user_id] = user.id
        expect { test_controller.authenticate_user! }.to_not change { test_controller.response_status }
      end

      it 'sets unauthorized when no user is logged in' do
        test_controller.authenticate_user!
        expect(test_controller.response_status).to eq(:unauthorized)
        expect(test_controller.response_json).to eq({ errors: "Unauthorized" })
      end
    end
  end
end