class CommentsController < ApplicationController
  allow_unauthenticated_access only: %i[ create ]

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    if current_user != nil
      @comment.user = current_user
    end

    puts @comment

    if @comment.save
      flash[:notice] = t("alerts.comments.comment_saved")
      redirect_to @post
    else
      flash[:alert] = t("alerts.comments.comment_save_error")
      redirect_to @post
    end
  end

  def update
  end

  def destroy
  end

  private

  def comment_params
    params.expect(comment: [ :content ])
  end
end
