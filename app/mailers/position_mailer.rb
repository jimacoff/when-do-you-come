class PositionMailer < ActionMailer::Base
  default from: "onthewaystartup2@gmail.com"

  def welcome_email(email, link)
    @link = link
    mail(to: email, subject: 'Welcome to My Awesome Site')
  end
end
