# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'People', type: :request do
  describe 'POST /people' do
    subject { post v1_people_path, params: { person: person_params } }

    context 'when valid' do
      let(:person_params) { { name: 'Lucky', cpf: '222333', birth_date: '2020-02-02' } }

      it 'returns http status created' do
        subject
        expect(response).to have_http_status(:created)
      end

      it 'returns json with created person' do
        subject
        expect(response.body).to eq('{"id":1,"name":"Lucky","cpf":"222333","birth_date":"2020-02-02"}')
      end

      it 'adds user to db' do
        expect { subject }.to change(Person, :count).by(1)
      end
    end

    context 'when not valid' do
      let(:person_params) { { name: '', cpf: '', birth_date: '' } }

      it 'returns http status unprocessable_entity' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not add user to db' do
        expect { subject }.to_not change(Person, :count)
      end

      it 'returns errors messages' do
        errors = { errors: [
          { message: "Name can't be blank" },
          { message: "Cpf can't be blank" }
        ] }
        subject
        expect(response.body).to eq(errors.to_json)
      end
    end
  end

  describe 'PATCH /people/:id' do
    context 'When valid' do
      let(:person_params) { { name: 'new_name' } }
      let(:person) { create(:person) }
      subject { patch v1_person_path(person), params: { person: person_params } }

      it 'returns http status ok' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'returns json with updated person' do
        subject
        expect(response.body).to eq('{"id":1,"name":"new_name","cpf":"999.666.999-66","birth_date":"2022-03-21"}')
      end

      it "changes person's attributes" do
        subject
        person.reload
        expect(person.name).to eq('new_name')
      end
    end

    context 'When not valid' do
      describe 'invalid id' do
        it 'returns http status not_found' do
          patch v1_person_path('invalid')
          expect(response).to have_http_status(:not_found)
        end
      end

      describe 'invalid params' do
        let(:person_params) { { name: '', cpf: '', birth_date: '' } }
        let(:person) { create(:person) }
        subject { patch v1_person_path(person), params: { person: person_params } }

        it 'returns http status unprocessable_entity' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns errors messages' do
          errors = { errors: [
            { message: "Name can't be blank" },
            { message: "Cpf can't be blank" }
          ] }
          subject
          expect(response.body).to eq(errors.to_json)
        end
      end
    end
  end

  describe 'DELETE /people/:id' do
    let(:person) { create(:person) }

    context 'When valid' do
      it 'returns http status ok' do
        delete v1_person_path(person)
        expect(response).to have_http_status(:ok)
      end

      it 'returns json with deleted person' do
        delete v1_person_path(person)
        expect(response.body).to eq('{"id":1,"name":"LuckGuy","cpf":"999.666.999-66","birth_date":"2022-03-21"}')
      end

      it 'removes record from db' do
        person
        expect { delete v1_person_path(person) }.to change(Person, :count).by(-1)
      end
    end

    context 'When not valid' do
      it 'returns http status not_found' do
        delete v1_person_path('invalid')
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
