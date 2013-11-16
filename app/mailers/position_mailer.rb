class PositionMailer < ActionMailer::Base
  default from: "from@example.com"

  def welcome_email(email, link)
    @link = link
    mail(to: email, subject: 'Welcome to My Awesome Site')
  end
end
