class UserMailer < ApplicationMailer
  default from: Setting[:default_emails_from]

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to TaskTracker!')
  end

  def notification(user)
    @user = user
    mail(to: @user.email, subject: 'TaskTracker Notifications!')
  end
end
