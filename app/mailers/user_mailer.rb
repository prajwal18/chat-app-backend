class UserMailer < ApplicationMailer
  
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

  def otp_email(user, otp)
    @user = user
    @otp = otp
    mail(to: @user.email, subject: 'Chat App - User verification OTP')
  end
end
