class NotifyUserMailer < ApplicationMailer
  default from: 'notifications@pedometer.com'

  def shoe_mileage_reached(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Pedometer Site')
  end
end
