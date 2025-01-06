class PasswordsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email_address: params[:email_address])
    if user
      # Store the raw token
      raw_token = user.generate_password_reset_token

      # Pass the raw token to mailer
      UserMailer.password_reset(user, raw_token).deliver_now!
      redirect_to root_path, notice: "Email sent with password reset instructions"
    else
      redirect_to :new_password, alert: "Email address not found"
    end
  end

  def edit
    @user = User.find_by(password_reset_token: params[:token])
    if @user.password_reset_expired?
      redirect_to new_password_reset_path, alert: "Password reset has expired"
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Invalid reset token"
  end

  def update
    Rails.logger.debug "Params received in update: #{params.inspect}"
    @user = User.find_by(password_reset_token: params[:token])

    if @user.password_reset_expired?
      redirect_to new_password_reset_path, alert: "Password reset has expired"
    elsif @user.update(password_params)
      @user.update(password_reset_token: nil)
      redirect_to :login_path, notice: "Password has been reset"
    else
      render :edit
    end
  end

  private

  def password_params
    params.expect(user: [ :email_address, :first_name, :last_name, :password, :password_confirmation ])
  end
end
