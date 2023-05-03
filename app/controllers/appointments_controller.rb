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
        Slot.update_currency_and_user_id(@params, @user.id)
        @slot = Slot.find(@params[:slot_id])
        UserMailer.notify(@user, @slot).deliver_later(wait_until: @slot.slot_time + 165.minutes)
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
end



