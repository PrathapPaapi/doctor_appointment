class UserMailer < ApplicationMailer
  helper :application

  default from: 'prathaprocks999@gmail.com'

  def notify(user, slot)
    @user = user
    @slot = slot
    mail(to: @user.email, subject: "Appointment Confirmation")
  end
end
