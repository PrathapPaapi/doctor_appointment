class UserMailer < ApplicationMailer
  default from: 'prathaprocks999@gmail.com'

  def notify(user)
    @user = user
    mail(to: @user.email, subject: "Appointment Confirmation")
  end
end
