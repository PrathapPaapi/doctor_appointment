require 'rails_helper'

RSpec.describe Slot, type: :model do
  #schema
  it { is_expected.to have_db_column(:slot_time).of_type(:datetime) }
  it { is_expected.to have_db_column(:present).of_type(:boolean) }
  it { is_expected.to have_db_column(:available).of_type(:boolean) }
  it { is_expected.to have_db_column(:doctor_id).of_type(:integer) }
  it { is_expected.to have_db_column(:currency).of_type(:string) }
  it { is_expected.to have_db_column(:currency_rate).of_type(:decimal) }
  it { is_expected.to have_db_column(:user_id).of_type(:integer) }

  it { is_expected.to belong_to(:doctor) }

  describe 'slot model specs' do

    let(:doctor) { Doctor.create }
    let(:slot) { Slot.create!(
      slot_time: Time.now,
      present: true,
      available: true,
      doctor_id: doctor.id
      ) }
    let(:params) { { currency: 'INR' } }

    it 'demonstrates update_currency_and_user_id functionality' do
      slot.update_currency_and_user_id(params, 1)
      expect(slot.available).to eq(false)
      expect(slot.currency).to eq('INR')
      expect(slot.currency_rate).not_to eq(nil)
      expect(slot.user_id).to eq(1)
    end

    it 'demonstrates update_cancelled_slot functionality' do
      slot.update_cancelled_slot
      expect(slot.available).to eq(true)
      expect(slot.currency).to eq(nil)
      expect(slot.currency_rate).to eq(nil)
      expect(slot.user_id).to eq(nil)
    end
  end
end
