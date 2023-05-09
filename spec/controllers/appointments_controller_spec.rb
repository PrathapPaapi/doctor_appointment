require 'rails_helper'

RSpec.describe AppointmentsController do

  describe 'appointments_controller_specs' do
    describe '#index' do
      let(:doctor) { Doctor.create }
      let(:slot) {
        Slot.create( doctor_id: doctor.id )
      }

      let(:params) { { doctor_id: doctor.id } }
      it 'should get index' do
        get :index, params: params
        expect(response).to be_successful
        expect(assigns(:slots)).to eq(doctor.slots)
      end
    end

    describe '#slots' do
      let(:doctor) { Doctor.create }
      let(:today_slot) {
        Slot.create(
          slot_time: Time.now,
          doctor_id: doctor.id
        )
      }
      let(:tomorrow_slot) {
        Slot.create(
          slot_time: Time.now + 1.day,
          doctor_id: doctor.id
        )
      }

      let(:params) { { doctor_id: doctor.id , day: Time.now } }
      let(:get_request) { get :slots, params: params, as: :turbo_stream }

      it 'should get success response' do
        get_request
        expect(response).to be_successful
        expect(response.media_type).to eq Mime[:turbo_stream]
        expect(response).to render_template(layout: false)
        expect(response.body).to include('<turbo-stream action="update" target="slots">')
      end

      it 'assign slots' do
        get_request
        expect(assigns(:slots)).to eq([today_slot])
      end
    end

    describe '#add_details' do
      let(:doctor) { Doctor.create }
      let(:slot) {
        Slot.create(
          slot_time: Time.now,
          doctor_id: doctor.id
        )
      }

      let(:params) { { user: { slot_id: slot.id } } }
      let(:get_request) { get :congrats, params: params, as: :turbo_stream }

      it 'should get success response' do
        get_request
        expect(response).to be_successful
        expect(response.media_type).to eq Mime[:turbo_stream]
        expect(response).to render_template(layout: false)
        expect(response.body).to include('<turbo-stream action="update" target="second_page">')
      end
    end

    describe '#congrats' do
      let(:doctor) { Doctor.create }
      let(:slot) {
        Slot.create(
          slot_time: Time.now,
          doctor_id: doctor.id
        )
      }
      let(:params) { { user: { name: 'paapi', email: 'paapi@fakemail.com', slot_id: slot.id, currency: 'INR' } } }
      let(:get_request) { get :congrats, params: params, as: :turbo_stream }

      it 'should set session variable' do
        get_request
        expect(session[:user_email]).to eq('paapi@fakemail.com')
      end

      it 'should invoke update_currency_and_user_id method' do
        expect_any_instance_of(Slot).to receive(:update_currency_and_user_id)
        get_request
      end

      it 'should invoke user_mailer notify method' do
        expect(UserMailer).to receive(:notify).and_call_original
        get_request
      end

      it 'should get success response' do
        get_request
        expect(response).to be_successful
        expect(response.media_type).to eq Mime[:turbo_stream]
        expect(response).to render_template(layout: false)
        expect(response.body).to include('<turbo-stream action="update" target="second_page">')
      end
    end
  end


end
