class UserMailer < ApplicationMailer
  default from: 'chiragagrawal112233@gmail.com'

  def welcome_email(user)
    @user = user
    # byebug
    mail(to: @user.email, subject: 'Welcome to our services')
  end
end
