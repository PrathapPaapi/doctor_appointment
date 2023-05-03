class AppointmentsBookedController < ApplicationController
  def my_appointments
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
    @slots = if User.find_by(email:).nil?
               []
             else
               Slot.where(user_id: User.find_by(email:).id)
             end
  end

  def update_appointment_list
    slot_id = params[:slot_id]
    Slot.update_cancelled_slot(slot_id)
    redirect_to action: 'appointments_list'
  end

  def generate_invoice
    slot_id = params.require(:slot_id)
    respond_to do |format|
      format.csv do
        file_name = GenerateInvoice.invoice('CSV', slot_id)
        send_file file_name,
                  filename: file_name,
                  type: 'text/csv',
                  disposition: 'attachment'
      end
      format.text do
        file_name = GenerateInvoice.invoice('TXT', slot_id)
        send_file file_name,
                  filename: file_name,
                  type: 'text/txt',
                  disposition: 'attachment'
      end
      format.pdf do
        file_name = GenerateInvoice.invoice('PDF', slot_id)
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
end
