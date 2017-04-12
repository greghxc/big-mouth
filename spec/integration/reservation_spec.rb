require 'swagger_helper'

describe 'Reservation API' do
  path '/reservation' do
    get 'Index of reservations' do
      tags 'Reservations'
      produces 'application/json'

      response '200', 'index' do
        schema type: 'array',
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              number: { type: :string },
              active: { type: :boolean },
              created_at: { type: :string },
              updated_at: { type: :string },
              twilio_number_id: { type: :integer },
              driver_number: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  number: { type: :string },
                  reservation_id: { type: :integer },
                  created_at: { type: :string },
                  updated_at: { type: :string }
                }
              },
              external_numbers: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    id: { type: :integer },
                    number: { type: :string },
                    created_at: { type: :string },
                    updated_at: { type: :string },
                    reservation_id: { type: :string }
                  }
                }
              }
            }
          }
        run_test!
      end
    end
  end

  path '/reservation' do
    post 'Add reservation' do
      tags 'Reservations'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :reservation, in: :body, schema: {
        type: :object,
        properties: {
          number: { type: :string, default: 'ABC123' },
          driver_number: { type: :string, default: '+12065552121' },
          external_number: { type: :string, default: '+12065551212' }
        },
        required: %w(number driver_number external_number)
      }

      response '201', 'reservation created' do
        schema type: :object,
          properties: {
            status: { type: :string },
            number: { type: :string }
          }
        let(:reservation) {
          TwilioNumber.create(number: '+12065552222')
          { number: 'ABC123', driver_number: '+12065551212', external_number: '+12065552121' }
        }
        run_test!
      end

      response '422', 'invalid request' do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string }
          }
        let(:reservation) {
          TwilioNumber.create(number: '+12065552222')
          { number: 'ABC123', driver_number: '+12065551212' }
        }
        run_test!
      end

      response '422', 'invalid request' do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string }
          }
        let(:reservation) {
          { number: 'ABC123', driver_number: '+12065551212', external_number: '+12065552121' }
        }
        run_test!
      end
    end
  end

  path '/reservation/{res_num}' do
    put 'Edit reservation by reservation number' do
      tags 'Reservations'
      parameter name: :res_num, in: :path, type: :string
      parameter name: :driver_number, in: :query, type: :string

      response 200, 'reservation updated' do
        let(:res_num) do
          r = Reservation.new(number: 'ABC123')
          r.build_driver_number(number: '+12065551212')
          r.external_numbers << ExternalNumber.new(number: '+12065552121')
          r.save
          r.number
        end
        let(:driver_number) { '+12069990000' }
        run_test!
      end
    end
    delete 'Delete reservation by reservation number' do
      tags 'Reservations'
      parameter name: :res_num, in: :path, type: :string

      response 204, 'reservation deleted' do
        let(:res_num) do
          r = Reservation.new(number: 'ABC123')
          r.build_driver_number(number: '+12065551212')
          r.external_numbers << ExternalNumber.new(number: '+12065552121')
          r.save
          r.number
        end
        run_test!
      end
    end
  end
  path ''
end
