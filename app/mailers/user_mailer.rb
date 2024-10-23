class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    return unless @user.email.present?
    mail(to: @user.email, subject: 'Welcome to our services')
  end
end
