class PostsController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]
  before_action :set_post, only: %i[ show edit update destroy ]

  def index
    @posts = Post.includes(:tags, :user).order(created_at: :desc).page(params[:page]).per(3)

    if params[:query]
      @posts = @posts.joins(:tags).where("title ILIKE ? OR tags.name ILIKE ?",
        "%#{params[:query]}%",
        "%#{params[:query]}%"
      ).distinct
    end
  end

  def show
    @post = Post.includes(:tags, :user).find_by(id: params[:id])
    @comments = @post.comments.order(created_at: :desc).page(params[:page]).per(3)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    if @post.save
      tags = params[:post][:tags].split(",").map(&:strip)

      tags.each do |tag_name|
        tag = Tag.find_or_create_by(name: tag_name)
        @post.tags << tag
      end

      redirect_to @post
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    tags = Tag.where(post_id: params[:id]).find_each
    @tags_string = ""

    tags.each_with_index { | tag, index |
      if index < tags.count - 2
        @tags_string.concat(tag.name, ", ")
      else
        @tags_string.concat(tag.name)
      end
    }
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      @post.tags.clear

      tags = params[:post][:tags].split(",").map(&:strip)
      tags.each do |tag_name|
        tag = Tag.find_or_create_by(name: tag_name, post_id: @post.id)
        @post.tags << tag
      end

      redirect_to @post
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path
  end

  private

  def set_post
    @post = Post.includes(:tags, :user).find(params[:id])
  end

  def post_params
    params.expect(post: [ :title, :content ])
  end
end
