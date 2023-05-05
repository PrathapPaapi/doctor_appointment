class AppointmentsController < ApplicationController
  require 'uri'
  require 'net/http'
  require 'json'

  before_action :find_slot_id, only: [:add_details]
  before_action :find_slot, only: [:congrats]

  WAIT_TIME_FOR_EMAIL_DELIVERY = 165
  def index
    @doctor_id = Doctor.find_by_id(params[:doctor_id]).id
    @slots = Doctor.find(@doctor_id).slots
  end

  def select_slot; end

  def slots
    @doctor = Doctor.find_by_id(params[:doctor_id])
    @day = Date.parse(params[:day])
    @slots = @doctor.slots_for_day @day

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(:slots, partial: 'appointments/slots')
      end
    end
  end

  def add_details
    @user = User.new
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(:second_page, partial: 'appointments/add_details')
      end
    end
  end

  def congrats
    @params = user_params
    @user = User.find_or_initialize_by(email: @params[:email])
    @user.name = @params[:name]
    respond_to do |format|
      sleep 1
      if @user.save
        session[:user_email] = @user.email
        @slot.update_currency_and_user_id(@params, @user.id)
        UserMailer.notify(@user, @slot).deliver_later(wait_until: @slot.slot_time + WAIT_TIME_FOR_EMAIL_DELIVERY.minutes)
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(:second_page, partial: 'appointments/congrats')
        end
      else
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

  def find_slot_id
    @slot_id = params[:slot_id]
  end

  def find_slot
    slot_id = params.require(:user).permit(:slot_id)[:slot_id]
    @slot = Slot.find(slot_id)
  end
end



