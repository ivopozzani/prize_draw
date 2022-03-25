# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'v1/people', type: :request do
  path '/v1/people' do
    get('list people') do
      response(200, 'successful') do
        examples 'application/json' => [{
          id: 1,
          name: 'Richard Wilson',
          cpf: '333.333.888-99',
          birth_date: '2021-03-22'
        },
                                        {
                                          id: 2,
                                          name: 'Maria Candida',
                                          cpf: '222.333.222-99',
                                          birth_date: '2022-03-22'
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

    post('create person') do
      consumes 'application/json'
      parameter name: :blog, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          cpf: { type: :string },
          birth_date: { type: :string }
        },
        required: %w[name cpf]
      }

      response(201, 'created') do
        examples 'application/json' => {
          name: 'Richard Wilson',
          cpf: '333.333.888-99',
          birth_date: '2021-03-22'
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

  path '/v1/people/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    patch('update person') do
      consumes 'application/json'
      parameter name: :blog, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          cpf: { type: :string },
          birth_date: { type: :string }
        }
      }

      response(200, 'successful') do
        let(:id) { '123' }

        examples 'application/json' => {
          name: 'Maria Candida'
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

    put('update person') do
      consumes 'application/json'
      parameter name: :blog, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          cpf: { type: :string },
          birth_date: { type: :string }
        }
      }

      response(200, 'successful') do
        let(:id) { '123' }

        examples 'application/json' => {
          name: 'Richard Wilson',
          cpf: '333.333.888-99',
          birth_date: '2021-03-22'
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

    delete('delete person') do
      response(200, 'successful') do
        let(:id) { '123' }

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
