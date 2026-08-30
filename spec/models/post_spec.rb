require 'rails_helper'

RSpec.describe Post, type: :model do
  # Standard validations using shoulda-matchers
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:body) }

  # Association
  it { is_expected.to belong_to(:user) }

  describe 'factory' do
    it 'has a valid factory' do
      post = FactoryBot.build(:post)
      expect(post).to be_valid
    end
  end

  # Additional validation tests
  describe 'validations' do
    it 'is invalid without title' do
      post = FactoryBot.build(:post, title: nil)
      expect(post).not_to be_valid
      expect(post.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without body' do
      post = FactoryBot.build(:post, body: nil)
      expect(post).not_to be_valid
      expect(post.errors[:body]).to include("can't be blank")
    end

    it 'is valid with title and body' do
      post = FactoryBot.build(:post)
      expect(post).to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      user = FactoryBot.create(:user)
      post = FactoryBot.create(:post, user: user)
      expect(post.user).to eq(user)
    end

    it 'destroys associated posts when user is destroyed' do
      user = FactoryBot.create(:user)
      post = FactoryBot.create(:post, user: user)
      expect { user.destroy }.to change { Post.count }.by(-1)
    end
  end
end
