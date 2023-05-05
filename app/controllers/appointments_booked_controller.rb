class AppointmentsBookedController < ApplicationController

  before_action :user_exists?, only: [:my_appointments]
  before_action :find_user, only: [:my_appointments]
  before_action :find_slot, only: [:cancel]

  def my_appointments
    @slots = Slot.where(available: false, user_id: @user.id)
  end

  def appointments_login; end

  def create_session
    session[:user_email] = login_param
    redirect_to action: 'my_appointments'
  end

  def cancel
    @slot.update_cancelled_slot
    redirect_to action: 'appointments_list'
  end

  def generate_invoice
    slot_id = params.require(:slot_id)
    respond_to do |format|
      format.csv do
        file_name = GenerateInvoice.generate('CSV', slot_id)
        send_file file_name,
                  filename: file_name,
                  type: 'text/csv',
                  disposition: 'attachment'
      end
      format.text do
        file_name = GenerateInvoice.generate('TXT', slot_id)
        send_file file_name,
                  filename: file_name,
                  type: 'text/txt',
                  disposition: 'attachment'
      end
      format.pdf do
        file_name = GenerateInvoice.generate('PDF', slot_id)
        send_file file_name,
                  filename: file_name,
                  type: 'application/pdf',
                  disposition: 'attachment'
      end
    end
  end

  private

  def login_param
    params.require(:email)
  end

  def user_exists?
    if session[:user_email].nil?
      flash[:error] = "You must be logged in to access this section"
      redirect_to action: 'appointments_login'
    end
  end

  def find_user
    @user = User.find_by(email: session[:user_email])
  end

  def findslot
    @slot = Slot.find params[:slot_id]
  end
end
