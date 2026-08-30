class Api::V1::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :authorize_user!, only: [:update, :destroy]

  # GET /api/v1/posts
  def index
    @posts = current_user.posts
    render json: @posts
  end

  # GET /api/v1/posts/:id
  def show
    render json: @post
  end

  # POST /api/v1/posts
  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      render json: @post, status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/posts/:id
  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/posts/:id
  def destroy
    @post.destroy
    head :no_content
  end

  private

  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Post not found" }, status: :not_found
  end

  def authorize_user!
    unless @post.user == current_user
      render json: { errors: "Unauthorized to access this post" }, status: :forbidden
    end
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end