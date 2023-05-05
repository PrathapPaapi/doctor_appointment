require 'rails_helper'

RSpec.describe Doctor, type: :model do
  #schema
  it { is_expected.to have_db_column(:doctor_name).of_type(:string) }
  it { is_expected.to have_db_column(:address).of_type(:text) }
  it { is_expected.to have_db_column(:image_url).of_type(:string) }
  
  describe 'doctor model specs' do
    doctor = nil
    before do
      doctor = Doctor.create(doctor_name: "dummy", address: "bangalore", image_url: "string")
      doctor.slots.create!(
        slot_time: Time.now,
        present: true,
        available: true
      )
      doctor.slots.create!(
        slot_time: Time.now + 1.day,
        present: true,
        available: true
      )
    end

    it 'demonstrates slots_for_day functionality' do
      expect(doctor.slots_for_day(Time.now)[0].id).to eq(doctor.slots.find(1).id)
      expect(doctor.slots_for_day(Time.now)[0].id).not_to eq(doctor.slots.find(2).id)
    end
  end
end
