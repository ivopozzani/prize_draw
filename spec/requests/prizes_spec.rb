# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Prizes', type: :request do
  describe 'POST /people/prizes' do
    let(:headers) { { Authorization: 'Bearer prize_draw_authorization' } }
    describe 'status ok' do
      it 'returns http status ok' do
        person = create(:person)

        post v1_people_prizes_path, headers: headers
        expect(response).to have_http_status(:ok)
      end

      it 'returns lucky one' do
        person = create(:person)

        post v1_people_prizes_path, headers: headers
        expect(response.body).to eq({ name: 'LuckGuy', cpf: '999.666.999-66',
                                      drawn_date: Time.now.strftime('%F') }.to_json)
      end
    end

    describe 'status unprocessable_entity' do
      it 'returns http status unprocessable_entity' do
        post v1_people_prizes_path, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns not elegible person for prize drawn' do
        post v1_people_prizes_path, headers: headers
        expect(response.body).to eq({ errors: [{ message: "There's no elegible person for this prize drawn" }] }.to_json)
      end
    end

    describe 'status unauthorized' do
      it 'returns http status unauthorized' do
        post v1_people_prizes_path
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns http status unauthorized' do
        post v1_people_prizes_path
        expect(response.body).to include('HTTP Token: Access denied.')
      end
    end
  end
end
