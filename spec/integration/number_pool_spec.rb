require 'swagger_helper'

describe 'Number Pool API' do
  path '/number_pool' do
    get 'Index of pool numbers' do
      tags 'Number Pool'
      produces 'application/json'

      response '200', 'index' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              number: { type: :string },
              assigned: { type: :boolean },
              created_at: { type: :string },
              updated_at: { type: :string }
            }
          }
        run_test!
      end
    end

    post 'Add number to pool' do
      tags 'Number Pool'
      produces 'application/json'
      parameter name: :number, in: :query, type: :string

      response '201', 'number created' do
        let(:number) { '+12223334444' }
        run_test!
      end
    end
  end

  path '/number_pool/{id}' do
    get 'Number by id' do
      tags 'Number Pool'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'number by id' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            number: { type: :string },
            assigned: { type: :boolean },
            created_at: { type: :string },
            updated_at: { type: :string }
          }
        let(:id) { TwilioNumber.create(number: '+12223334444').id }
        run_test!
      end
    end

    delete 'Delete number by id' do
      tags 'Number Pool'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '204', 'number deleted' do
        let(:id) { TwilioNumber.create(number: '+12223334444').id }
        run_test!
      end
    end
  end
end
