require 'rails_helper'

RSpec.describe ReservationController, type: :controller do
  let(:twilio_number) { FactoryGirl.create(:twilio_number) }
  # let(:twilio_number) { TwilioNumber.create(number: '+12069876543') }
  let(:driver_number) { '+12065551212' }
  let(:external_number) { '+12065551213' }

  before(:example) do
    twilio_number
  end

  it 'fails with no parameters' do
    get :create
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it 'succeeds with required params' do
    get :create, number: 'ABC1234', external_number: external_number, driver_number: driver_number
    expect(response).to have_http_status(:created)
  end

  it 'creates reservation' do
    get :create, number: 'ABC1234', external_number: external_number, driver_number: driver_number
    r = Reservation.find_by_number('ABC1234')
    expect(r.number).to eq('ABC1234')
    expect(r.external_numbers.first.number).to eq(external_number)
    expect(r.driver_number.number).to eq(driver_number)
  end

  it 'edits driver number' do
    expected_number = '+12064442121'
    get :create, number: 'ABC1234', external_number: external_number, driver_number: driver_number
    put :edit, res_num: 'ABC1234', driver_number: expected_number
    r = Reservation.find_by_number('ABC1234')
    expect(r.driver_number.number).to eq(expected_number)
  end
end
