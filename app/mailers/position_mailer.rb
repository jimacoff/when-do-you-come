class PositionMailer < ActionMailer::Base
  default from: "startup@onmyway.com"

  def welcome_email(email, link)
    @link = link
    mail(to: email, subject: 'Welcome to My Awesome Site')
  end
end
