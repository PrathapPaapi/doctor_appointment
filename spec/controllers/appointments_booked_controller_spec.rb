require 'rails_helper'

RSpec.describe AppointmentsBookedController do
  describe '#my_appointments' do
    let(:doctor) { Doctor.create }
    let(:user) do
      User.create(
        name: 'paapi',
        email: 'paapi@fakemail.com'
      )
    end
    let(:first_slot) do
      Slot.create(
        slot_time: Time.now,
        doctor_id: doctor.id,
        available: false,
        user_id: user.id
      )
    end
    let(:second_slot) do
      Slot.create(
        slot_time: Time.now,
        doctor_id: doctor.id,
        available: true,
        user_id: user.id
      )
    end

    let(:get_request) { get :my_appointments }

    it 'assign slots' do
      session[:user_email] = user.email
      get_request
      expect(assigns(:slots)).to eq([first_slot])
    end

    it 'should get success response when session[:user_email] is set' do
      session[:user_email] = user.email
      get :my_appointments
      expect(response).to be_successful
    end

    it 'should not get success response when session[:user_email] is not set' do
      session[:user_email] = nil
      get :my_appointments
      expect(response).not_to be_successful
    end

    it 'should show redirection to appointments_login when session[:user_email] is not set' do
      session[:user_email] = nil
      get :my_appointments
      expect(response).to redirect_to(appointments_booked_appointments_login_path)
    end
  end

  describe '#create_session' do
    let(:doctor) { Doctor.create }
    let(:user) do
      User.create(
        name: 'paapi',
        email: 'paapi@fakemail.com'
      )
    end
    let(:slot) do
      Slot.create(
        slot_time: Time.now,
        doctor_id: doctor.id,
        available: false,
        user_id: user.id
      )
    end
    let(:params) { { email: 'paapi@fakemail.com' } }

    it 'should show redirection to my_appointments after session is created' do
      get :create_session, params: params
      expect(response).to redirect_to(appointments_booked_my_appointments_path)
    end
  end

  describe '#cancel' do
    let(:doctor) { Doctor.create }
    let(:slot) do
      Slot.create(
        slot_time: Time.now,
        doctor_id: doctor.id,
        available: false
      )
    end
    let(:params) { { slot_id: slot.id } }
    it 'should invoke update_cancelled_slot method' do
      expect_any_instance_of(Slot).to receive(:update_cancelled_slot)
      get :cancel, params: params
    end

    it 'should show redirection to my_appointments after session is created' do
      get :cancel, params: params
      expect(response).to redirect_to(appointments_booked_my_appointments_path)
    end
  end

  describe '#generate_invoice' do
    let(:doctor) { Doctor.create }
    let(:user) do
      User.create(
        name: 'paapi',
        email: 'paapi@fakemail.com'
      )
    end
    let(:slot) do
      Slot.create(
        slot_time: Time.now,
        doctor_id: doctor.id,
        available: false,
        user_id: user.id,
        currency_rate: 1,
        currency: 'INR'
      )
    end
    let(:params) { { slot_id: slot.id } }

    it 'generates CSV file' do
      get :generate_invoice, params: params, format: :csv
      expect(response.header['Content-Type']).to include 'text/csv'
    end

    it 'generates TXT file' do
      get :generate_invoice, params: params, format: :txt
      expect(response.header['Content-Type']).to include 'text/txt'
    end

    it 'generates PDF file' do
      get :generate_invoice, params: params, format: :pdf
      expect(response.header['Content-Type']).to include 'application/pdf'
    end
  end
end