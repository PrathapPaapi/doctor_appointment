class AppointmentsBookedController < ApplicationController
  def my_appointments
    # binding.pry
    if session[:user_email].nil?
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
    if User.find_by(email: email).nil?
      @slots = []
    else
      @slots = Slot.where(user_id: User.find_by(email: email).id)
    end
  end

  def update_appointment_list
    slot_id = params[:slot_id]
    update_slot_parameters(slot_id)
    redirect_to action: 'appointments_list'
  end

  private
  def login_param
    params.require(:email)
  end
  def update_slot_parameters(slot_id)
    slot = Slot.find(slot_id)
    slot.user_id = nil
    slot.currency = nil
    slot.currency_rate = nil
    slot.available = true
    slot.save
  end
end
