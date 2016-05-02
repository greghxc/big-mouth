require 'rails_helper'

RSpec.describe ReservationController, type: :controller do
  it 'fails with no parameters' do
    get :create
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it 'succeeds with required params' do
    get :create, number: 'ABC1234', external_number: '2065551212', driver_number: '2065551212'
    expect(response).to have_http_status(:created)
  end

  it 'creates reservation' do
    get :create, number: 'ABC1234', external_number: '2065551212', driver_number: '2065551212'
    r = Reservation.find_by_number('ABC1234')
    expect(r.number).to eq('ABC1234')
    expect(r.external_numbers.first.number).to eq('2065551212')
    expect(r.driver_number.number).to eq('2065551212')
  end
end
