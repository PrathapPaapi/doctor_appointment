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

  def generate_invoice
    slot_id = params.require(:slot_id)
    respond_to do |format|
      format.csv do
        invoice("CSV", slot_id)
      end
      format.text do
        invoice("TXT", slot_id)
      end
      format.pdf do
        invoice("PDF", slot_id)
      end
    end
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

  def invoice(format, slot_id)
    slot = Slot.find(slot_id)
    user = User.find(slot.user_id)
    doctor = Doctor.find(slot.doctor_id)
    date = displayable_date(slot.slot_time)
    time = displayable_time(slot.slot_time)
    invoice_id = "#{user.name} #{user.email} #{Time.now}".to_i(36)
    amount_paid = "#{500 * slot.currency_rate} #{slot.currency}"
    file_name = nil
    if format == "CSV"
      file_name = "#{user.email}_#{invoice_id}.csv"
      CSV.open(file_name, "w",
               :write_headers=> true,
               :headers => ["Invoice Number", "Name", "Email", "Doctor Name", "Date", "Time", "Location", "Amount paid"]) do |csv|
        csv << [invoice_id, user.name, user.email, doctor.doctor_name, date, time, doctor.address, amount_paid  ]
      end
      send_file file_name,
                filename: file_name,
                type: 'text/csv',
                disposition: 'attachment'
    elsif format == "TXT"
      file_name = "#{user.email}_#{invoice_id}.txt"
      File.open(file_name, "w") do |f|
        f.write ("Generating invoice for Mr/Ms. #{user.name} \n\n")

        f.write ("Invoice Number  : #{invoice_id} \n")

        f.write ("Name            : #{user.name} \n")

        f.write ("Email           : #{user.email} \n")

        f.write ("Doctor Name     : Dr. #{doctor.doctor_name} \n")

        f.write ("Date            : #{date} \n")

        f.write ("Time            : #{time}\n")

        f.write ("Location        : #{doctor.address}\n")

        f.write ("Amount Paid     : #{amount_paid} \n")
      end
      send_file file_name,
                filename: file_name,
                type: 'text/txt',
                disposition: 'attachment'
    else
      # pdf_name = "#{user.email}_#{invoice_id}"
      # pdf = Prawn::Document.new
      # pdf.text "Generating invoice for Mr/Ms #{user.name}"
      #
      # pdf.text "\n"
      #
      # pdf.table([
      #             ["Invoice Number", "#{invoice_id}"],
      #             ["Name", "#{user.name}"],
      #             ["Email", "#{user.email}"],
      #             ["Doctor Name", "Dr. #{doctor.doctor_name}"],
      #             ["Date", "#{date}"],
      #             ["Time", "#{time}"],
      #             ["Location", "#{doctor.address}"],
      #             ["Amount Paid", "Rs. #{amount_paid}"],
      #           ])
      # pdf.render_file "#{pdf_name}.pdf"
      file_name = "#{user.email}_#{invoice_id}.pdf"
      pdf = PrawnRails::Document.new(filename: file_name) do |pdf|
        pdf.text "Generating invoice for Mr/Ms #{user.name}"
        pdf.text "Invoice Number  : #{invoice_id}"
        pdf.text "Name            : #{user.name}"
        pdf.text "Email           : #{user.email}"
        pdf.text "Doctor Name     : Dr. #{doctor.doctor_name}"
        pdf.text "Date            : #{date}"
        pdf.text "Time            : #{time}"
        pdf.text "Location        : #{doctor.address}"
        pdf.text "Amount Paid     : #{amount_paid}"
      end
      sample = pdf.render
      f = File.open(file_name, "wb") {|f|
        f.write(sample)
      }
      send_file file_name,
                filename: file_name,
                type: 'application/pdf',
                disposition: 'attachment'
    end
  end
end
