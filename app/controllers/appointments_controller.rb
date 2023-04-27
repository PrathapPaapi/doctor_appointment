class AppointmentsController < ApplicationController
  require 'uri'
  require 'net/http'
  require 'json'
  def index
    @doctor_id = Doctor.find_by_id(params[:doctor_id]).id
    @slots = Doctor.find(@doctor_id).slots
  end

  def select_slot; end

  def slots
    @doctor_id = Doctor.find_by_id(params[:doctor_id]).id
    @day = Date.parse(params[:day])
    @slots = Doctor.find(@doctor_id).slots.where("slot_time > ? AND slot_time < ?", @day.beginning_of_day, @day.end_of_day)
    @slot_id = params[:slot_id]
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(:slots, partial: 'appointments/slots')
      end
    end
  end

  def add_details
    @user = User.new
    @slot_id = params[:slot_id]
    @slot = Slot.find(@slot_id)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(:second_page, partial: 'appointments/add_details')
      end
    end
  end

  def congrats
    @params = user_params
    session[:user_email] = @params[:email]
    @user = User.find_or_initialize_by(email: @params[:email])
    @user.name = @params[:name]
    respond_to do |format|
      sleep 1
      if @user.save
        update_slots_with_currency_and_user_id(@params, @user.id)
        slot = Slot.find(@params[:slot_id])
        # UserMailer.notify(@user, slot).deliver_now
        # UserMailer.notify(@user).deliver_later(wait_until: 1.minute.from_now)
        UserMailer.notify(@user, slot).deliver_later(wait_until: slot.slot_time + 165.minutes)
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(:second_page, partial: 'appointments/congrats')
        end
      else
        # if @params[:currency].blank?
        #   @user.errors.add(:currency, "Please select a currency")
        # end
        puts @user.errors.full_messages
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(:second_page, partial: 'appointments/add_details')
        end
      end
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :slot_id, :currency)
  end

  def update_slots_with_currency_and_user_id(params, user_id)
    slot = Slot.find(params[:slot_id])
    slot.available = false
    slot.currency = params[:currency]
    slot.currency_rate = get_currency_rate(params[:currency])
    slot.user_id = user_id
    slot.save
  end

  def get_currency_rate(currency)
    uri = URI('https://api.apilayer.com/fixer/latest?base=INR&symbols=USD,EUR')

    req = Net::HTTP::Get.new(uri)
    req['apikey'] = "um7M9O55ZPPzpRHbdpxdHnWp8SdUSE6a"

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') { |http|
      http.request(req)
    }
    currency_rate = JSON.parse(res.body)["rates"][currency]
    if currency_rate==nil
      currency_rate = 1
    end
    currency_rate
  end
end



