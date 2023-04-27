class AppointmentsBookedController < ApplicationController
  def my_appointments
    # binding.pry
    if !session[:user_email].nil?
      redirect_to action: 'appointments_login'
    else
      redirect_to action: 'appointments_list'
    end
  end

  def appointments_login; end

  def appointments_list
    email = if session[:user_email].nil?
              session[:user_email] = login_param
            else
              session[:user_email]
            end
    @slots = Slot.where(user_id: User.find_by(email: email).id)
  end

  private
  def login_param
    params.require(:email)
  end
end
