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
    @user = User.find(current_user.id)
  end

  private

  def allowed_user_params
    params.expect(user: [ :email_address, :first_name, :last_name, :password, :password_confirmation ])
  end
end
