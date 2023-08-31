class ApplicationMailer < ActionMailer::Base
  default from: "notifications@pedometer.com"
  layout "mailer"
end
