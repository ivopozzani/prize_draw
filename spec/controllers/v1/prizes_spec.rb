# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::PrizesController, type: :request do
  describe 'GET /people/prizes' do
    it 'returns http status ok' do
      get v1_people_prizes_path
      expect(response).to have_http_status(:ok)
    end

    it 'returns lucky people' do
      lucky_people = [
        { name: 'LuckGuy1', cpf: '999.666.999-66', drawn_at: Time.now },
        { name: 'LuckGuy2', cpf: '99.666.999-66', drawn_at: Time.now },
        { name: 'LuckGuy3', cpf: '9.666.999-66', drawn_at: Time.now }
      ]

      lucky_people.each do |lp|
        create(:person, name: lp[:name], cpf: lp[:cpf], drawn_at: lp[:drawn_at])
      end

      get v1_people_prizes_path
      expect(response.body).to include('LuckGuy1', 'LuckGuy2', 'LuckGuy3')
    end
  end

  describe 'POST /people/prizes' do
    let(:headers) { { Authorization: 'Bearer prize_draw_authorization' } }

    context 'when request is successful' do
      it 'returns http status ok' do
        create(:person)

        post v1_people_prizes_path, headers: headers
        expect(response).to have_http_status(:ok)
      end

      it 'returns lucky one' do
        random_people = [
          { name: 'LuckGuy1', cpf: '999.666.999-66', birth_date: '2022-03-21' },
          { name: 'LuckGuy2', cpf: '99.666.999-66', birth_date: '2022-03-21' },
          { name: 'LuckGuy3', cpf: '9.666.999-66', birth_date: '2022-03-21' }
        ]

        random_people.each do |rp|
          create(:person, name: rp[:name], cpf: rp[:cpf], birth_date: rp[:birth_date])
        end

        post v1_people_prizes_path, headers: headers
        expect(response.body).to include('LuckGuy')
      end
    end

    context "when there's no elegible person for prize draw" do
      describe 'due to no record on db' do
        it 'returns http status unprocessable_entity' do
          post v1_people_prizes_path, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns not elegible person for prize drawn' do
          post v1_people_prizes_path, headers: headers
          expect(response.body).to eq({ errors: [{ message: "There's no elegible person for this prize drawn" }] }.to_json)
        end
      end

      describe 'due to people have already been drawn' do
        before(:each) do
          create(:person, name: 'LuckGuy1', cpf: '999.666.999-66', drawn_at: Time.now)
          create(:person, name: 'LuckGuy2', cpf: '99.666.999-66', drawn_at: Time.now)
          create(:person, name: 'LuckGuy3', cpf: '9.666.999-66', drawn_at: Time.now)
        end

        it 'returns http status unprocessable_entity' do
          post v1_people_prizes_path, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns not elegible person for prize drawn' do
          expected = { errors: [{ message: "There's no elegible person for this prize drawn" }] }

          post v1_people_prizes_path, headers: headers
          expect(response.body).to eq(expected.to_json)
        end
      end
    end

    context 'when request is unauthorized' do
      it 'returns http status unauthorized' do
        post v1_people_prizes_path
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns proper message' do
        post v1_people_prizes_path
        expect(response.body).to include('HTTP Token: Access denied.')
      end
    end
  end
end
