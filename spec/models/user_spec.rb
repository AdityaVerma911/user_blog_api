require 'rails_helper'

RSpec.describe User, type: :model do
  # Standard validations using shoulda-matchers
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to allow_value('user@example.com').for(:email) }
  it { is_expected.not_to allow_value('invalid-email').for(:email) }

  it { is_expected.to have_secure_password }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_length_of(:password).is_at_least(8) }
  it { is_expected.to validate_confirmation_of(:password) }

  # Custom email uniqueness validation (case-insensitive)
  describe 'email uniqueness' do
    let(:existing_user) { FactoryBot.create(:user, email: 'existing@example.com') }

    it 'rejects duplicate email (case-insensitive)' do
      new_user = FactoryBot.build(:user, email: existing_user.email.upcase)
      expect(new_user).not_to be_valid
      expect(new_user.errors[:email]).to include('has already been taken')
    end
  end

  # Custom password strength validation
  describe 'password strength validation' do
    it 'requires strong password' do
      user = User.new(email: 'test@example.com')

      # Test too short
      user.password = user.password_confirmation = 'Ab1!'
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('is too short (minimum is 8 characters)')

      # Test missing uppercase
      user.password = user.password_confirmation = 'abcdefg1!'
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('must include at least one lowercase letter, one uppercase letter, one digit, and one special character')

      # Test missing lowercase
      user.password = user.password_confirmation = 'ABCDEFG1!'
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('must include at least one lowercase letter, one uppercase letter, one digit, and one special character')

      # Test missing digit
      user.password = user.password_confirmation = 'Abcdefg!'
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('must include at least one lowercase letter, one uppercase letter, one digit, and one special character')

      # Test missing special character
      user.password = user.password_confirmation = 'Abcdefg1'
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('must include at least one lowercase letter, one uppercase letter, one digit, and one special character')

      # Test valid strong password
      user.password = user.password_confirmation = 'Abcdefg1!'
      expect(user).to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:posts).dependent(:destroy) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end
  end
end

