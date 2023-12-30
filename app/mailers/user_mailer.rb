class UserMailer < ApplicationMailer
  
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

  def otp_email(user, otp, expires_at)
    @user = user
    @otp = otp
    @expires_at = expires_at
    mail(to: @user.email, subject: 'Chat App - User verification OTP')
  end
end
