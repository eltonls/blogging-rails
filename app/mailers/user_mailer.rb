class UserMailer < ApplicationMailer
  default from: "MS_IdxTra@trial-z86org80w0z4ew13.mlsender.net "

  def confirmation_email
    @user = params[:user]
    @confirmation_token = @user.confirmation_token
    @confirmation_url = confirm_email_url(token: @confirmation_token)
    @url = "https://mailersend.com/login"

    mail(
      to: @user.email_address,
      subject: t("mailer.user.confirmation_subject")
    )
  end

  def password_reset(user, token)
      @user = user
      @reset_url = edit_passwords_url(token: token)

      mail(
        to: user.email_address,
        subject: t("mailer.user.password_reset_subject")
      )
  end
end
