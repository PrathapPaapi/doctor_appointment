require 'rails_helper'

RSpec.describe GenerateInvoice do
  describe 'generate_invoice specs' do
    let(:doctor) do
      Doctor.create(
        doctor_name: 'Eren',
        address: 'Bangalore',
        image_url: 'string'
      )
    end

    let(:user) do
      User.create(
        name: 'paapi',
        email: 'paapi@fakemail.com'
      )
    end

    let(:slot) do
      Slot.create!(
        slot_time: Time.now,
        present: true,
        available: true,
        doctor_id: doctor.id,
        user_id: user.id,
        currency: 'INR',
        currency_rate: 1
      ) end

    let(:invoice_in_csv_object) { GenerateInvoice.new('CSV', slot.id) }
    let(:invoice_in_txt_object) { GenerateInvoice.new('TXT', slot.id) }
    let(:invoice_in_pdf_object) { GenerateInvoice.new('PDF', slot.id) }

    it 'tests functionality of generate method and invoice_in_csv method' do
      expect(invoice_in_csv_object.generate).to eq("#{user.email}_#{invoice_in_csv_object.invoice_id}.csv")
    end

    it 'tests functionality of generate method and invoice_in_txt method' do
      expect(invoice_in_txt_object.generate).to eq("#{user.email}_#{invoice_in_txt_object.invoice_id}.txt")
    end

    it 'tests functionality of generate method and invoice_in_pdf method' do
      expect(invoice_in_pdf_object.generate).to eq("#{user.email}_#{invoice_in_pdf_object.invoice_id}.pdf")
    end

  end
end