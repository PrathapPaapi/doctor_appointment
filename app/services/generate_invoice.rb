class GenerateInvoice
  include ApplicationHelper
  def self.invoice(format, slot_id)
    new(format, slot_id).invoice
  end

  attr_reader :slot, :user, :doctor, :date, :time, :invoice_id, :amount_paid, :format

  def initialize(format, slot_id)
    @slot = Slot.find(slot_id)
    @user = User.find(slot.user_id)
    @doctor = Doctor.find(slot.doctor_id)
    @date = displayable_date(slot.slot_time)
    @time = displayable_time(slot.slot_time)
    @invoice_id = "#{user.name} #{user.email} #{Time.now}".to_i(36)
    @amount_paid = "#{500 * slot.currency_rate} #{slot.currency}"
    @format = format
  end

  def invoice
    case @format
    when 'CSV'
      invoice_in_csv
    when 'TXT'
      invoice_in_txt
    else
      invoice_in_pdf
    end
  end

  def invoice_in_csv
    file_name = "#{@user.email}_#{@invoice_id}.csv"
    CSV.open(file_name, 'w',
             :write_headers=> true,
             :headers => ['Invoice Number', 'Name', 'Email', 'Doctor Name', 'Date', 'Time', 'Location', 'Amount paid']) do |csv|
                csv << [@invoice_id, @user.name, @user.email, @doctor.doctor_name, @date, @time, @doctor.address, @amount_paid]
              end
    file_name
  end

  def invoice_in_txt
    file_name = "#{@user.email}_#{@invoice_id}.txt"
    File.open(file_name, 'w') do |f|
      f.write("Generating invoice for Mr/Ms. #{@user.name} \n\n")
      f.write("Invoice Number  : #{@invoice_id} \n")
      f.write("Name            : #{@user.name} \n")
      f.write("Email           : #{@user.email} \n")
      f.write("Doctor Name     : Dr. #{@doctor.doctor_name} \n")
      f.write("Date            : #{@date} \n")
      f.write("Time            : #{@time}\n")
      f.write("Location        : #{@doctor.address}\n")
      f.write("Amount Paid     : #{@amount_paid} \n")
    end
    file_name
  end

  def invoice_in_pdf
    file_name = "#{@user.email}_#{@invoice_id}.pdf"
    pdf = PrawnRails::Document.new(filename: file_name) do |pdf|
      pdf.text "Generating invoice for Mr/Ms #{@user.name}"
      pdf.text "Invoice Number  : #{@invoice_id}"
      pdf.text "Name            : #{@user.name}"
      pdf.text "Email           : #{@user.email}"
      pdf.text "Doctor Name     : Dr. #{@doctor.doctor_name}"
      pdf.text "Date            : #{@date}"
      pdf.text "Time            : #{@time}"
      pdf.text "Location        : #{@doctor.address}"
      pdf.text "Amount Paid     : #{@amount_paid}"
    end
    sample = pdf.render
    f = File.open(file_name, 'wb') {|f|
      f.write(sample)
    }
    file_name
  end
end