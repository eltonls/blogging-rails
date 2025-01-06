class ConfirmationController < ApplicationController
  def confirm
    user = User.find_by(confirmation_token: params[:token])

    if user&.confirmation_sent_at&.> 24.hours.ago
      user.confirm!
      session[:user_id] = user.id
      redirect_to root_path, notice: t("confirm.alerts.success")
    else
      redirect_to root_path, alert: t("confirm.alerts.fail")
    end
  end
end
