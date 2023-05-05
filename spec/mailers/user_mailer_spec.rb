require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do

  let(:user) { User.create(name: 'paapi', email: 'paapi@fakemail.com') }
  let(:sender_email) { ['prathaprocks999@gmail.com'] }
  let(:doctor) { Doctor.create }
  let(:slot) {
                Slot.create!(
                slot_time: Time.now,
                present: true,
                available: true,
                doctor_id: doctor.id,
                currency: 'INR',
                currency_rate: 1
            ) }

  let(:mail) { UserMailer.notify(user, slot) }

  describe "user_mailer" do
    it "sets sender email" do
      expect(mail.from).to eq(sender_email)
    end

    it "sets receiver email" do
      expect(mail.to).to eq([user.email])
    end

    it "checks subject of email" do
      expect(mail.subject).to eq("Appointment Confirmation")
    end

    it 'checks whether mail body has user name' do
      expect(mail.body).to include user.name
    end
  end
end