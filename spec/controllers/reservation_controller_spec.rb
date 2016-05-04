require 'rails_helper'

RSpec.describe ReservationController, type: :controller do
  let(:twilio_number) { TwilioNumber.create(number: '+12069876543') }
  let(:driver_number) { '+12065551212' }
  let(:external_number) { '+12065551213' }

  before(:example) do
    puts twilio_number.inspect
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
end
