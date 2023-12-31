class PasswordMailer < ApplicationMailer
  default from: "from@example.com"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.password_mailer.reset_password_email.subject
  #
  def reset_password_email(user)
    @user = User.find(user.id)
    @url = edit_api_password_reset_url(@user.reset_password_token)
    mail(:to => user.email,
      :subject => "パスワードリセット用メール"
    )
  end
end
