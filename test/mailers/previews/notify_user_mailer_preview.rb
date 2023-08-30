# Preview all emails at http://localhost:3000/rails/mailers/notify_user_mailer
class NotifyUserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notify_user_mailer/shoe_limit_reached
  def shoe_limit_reached
    NotifyUserMailer.shoe_limit_reached
  end

end
