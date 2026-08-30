require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  # Helper method to sign in a user
  def sign_in(user)
    post '/api/v1/login', params: { email: user.email, password: 'Password@123' }
  end

  describe 'GET /api/v1/posts' do
    it 'returns a list of the current user\'s posts' do
      sign_in(user)
      get '/api/v1/posts'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_an(Array)
    end
  end

  describe 'GET /api/v1/posts/:id' do
    it 'returns the requested post' do
      post = FactoryBot.create(:post, user: user)
      sign_in(user)
      get "/api/v1/posts/#{post.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(post.id)
    end

    it 'returns not found for non-existent post' do
      sign_in(user)
      get '/api/v1/posts/0'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/v1/posts' do
    let(:valid_params) { { post: { title: 'Test Post', body: 'Test body' } } }
    let(:invalid_params) { { post: { title: '', body: '' } } }

    it 'creates a new post with valid parameters' do
      sign_in(user)
      expect {
        post '/api/v1/posts', params: valid_params
      }.to change(user.posts, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it 'returns errors with invalid parameters' do
      sign_in(user)
      expect {
        post '/api/v1/posts', params: invalid_params
      }.not_to change(user.posts, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH /api/v1/posts/:id' do
    it 'updates the post when authorized' do
      post = FactoryBot.create(:post, user: user)
      sign_in(user)
      patch "/api/v1/posts/#{post.id}", params: { post: { title: 'Updated Title' } }
      expect(response).to have_http_status(:ok)
      expect(post.reload.title).to eq('Updated Title')
    end

    it 'returns unauthorized when trying to update another user\'s post' do
      post = FactoryBot.create(:post, user: user)
      sign_in(other_user)
      patch "/api/v1/posts/#{post.id}", params: { post: { title: 'Updated Title' } }
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'DELETE /api/v1/posts/:id' do
    it 'deletes the post when authorized' do
      post = FactoryBot.create(:post, user: user)
      sign_in(user)
      expect {
        delete "/api/v1/posts/#{post.id}"
      }.to change(Post, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it 'returns forbidden when trying to delete another user\'s post' do
      post = FactoryBot.create(:post, user: user)
      sign_in(other_user)
      delete "/api/v1/posts/#{post.id}"
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'authentication' do
    it 'returns unauthorized when not logged in' do
      get '/api/v1/posts'
      expect(response).to have_http_status(:unauthorized)
    end
  end
end