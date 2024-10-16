class UserMailer < ApplicationMailer
  default from: ENV['EMAIL_USERNAME']

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to our services')
  end
end
