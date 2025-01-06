class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(allowed_user_params)

    if @user.save
      UserMailer.with(user: @user).confirmation_email.deliver_now!
      redirect_to root_path, notice: t("confirmation.alerts.check_email")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.includes(:posts).find(current_user.id)
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(3)
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user[:id])

    last_email = @user.email_address

    if @user.update(allowed_user_params)
      @user.generate_confirmation_token
      if last_email != @user.email_address
        UserMailer.with(user: @user).confirmation_email.deliver_now!
      end

      redirect_to :profile_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def allowed_user_params
    params.expect(user: [ :email_address, :first_name, :last_name, :password, :password_confirmation ])
  end
end
