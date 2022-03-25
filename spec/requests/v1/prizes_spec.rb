# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'v1/prizes', type: :request do
  path '/v1/people/prizes' do
    get('list prizes') do
      response(200, 'successful') do
        examples 'application/json' => [{
          name: 'Richard Wilson',
          cpf: '333.333.888-99',
          drawn_at: '2022-03-24T19:45:00.950Z'
        },
                                        {
                                          name: 'Maria Candida',
                                          cpf: '222.333.222-99',
                                          drawn_at: '2022-03-24T18:56:00.950Z'
                                        }]

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    post('create prize') do
      parameter name: 'Authorization', in: :header, type: :string
      response(200, 'successful') do
        examples 'application/json' => {
          name: 'Richard Wilson',
          cpf: '333.333.888-99',
          drawn_at: '2022-03-24T19:45:00.950Z'
        }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(401, 'unauthorized') do
        examples 'application/json' => 'HTTP Token: Access denied.'

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(422, 'unprocessable entity') do
        examples 'application/json' => {
          errors: [
            {
              message: "There's no elegible person for this prize drawn"
            }
          ]
        }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
