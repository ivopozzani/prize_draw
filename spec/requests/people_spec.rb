# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'People', type: :request do
  describe 'GET /people' do
    it 'returns http status ok' do
      get v1_people_path
      expect(response).to have_http_status(:ok)
    end

    it 'returns all people' do
      create(:person, cpf: '12333333')
      create(:person, cpf: '1234444')
      people = [{ id: 1, name: 'LuckGuy', cpf: '12333333', birth_date: '2022-03-21' },
                { id: 2, name: 'LuckGuy', cpf: '1234444', birth_date: '2022-03-21' }]

      get v1_people_path
      expect(response.body).to eq(people.to_json)
    end
  end

  describe 'POST /people' do
    subject { post v1_people_path, params: { person: person_params } }

    context 'when valid' do
      let(:person_params) { { name: 'Lucky', cpf: '222333', birth_date: '2020-02-02' } }

      it 'returns http status created' do
        subject
        expect(response).to have_http_status(:created)
      end

      it 'returns json with created person' do
        expected = { id: 1, name: 'Lucky', cpf: '222333', birth_date: '2020-02-02' }

        subject
        expect(response.body).to eq(expected.to_json)
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
      let(:person_params) { { name: 'new_name', cpf: '00011122', birth_date: '2020-02-02' } }
      let(:person) { create(:person) }

      subject do
        patch v1_person_path(person.id), params: { person: person_params }
        person.reload
      end

      it 'returns http status ok' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'returns json with updated person' do
        expected = { id: 1, name: 'new_name', cpf: '00011122', birth_date: '2020-02-02' }

        subject
        expect(response.body).to eq(expected.to_json)
      end

      it "changes person's name attribute" do
        expect { subject }.to change(person, :name).from('LuckGuy').to('new_name')
      end

      it "changes person's cpf attribute" do
        expect { subject }.to change(person, :cpf).from('999.666.999-66').to('00011122')
      end

      it "changes person's birth_date attribute" do
        expect { subject }.to change(person, :birth_date).from(Date.parse('2022-03-21')).to(Date.parse('2020-02-02'))
      end
    end

    context 'When not valid' do
      describe 'invalid id' do
        let(:person_params) { { name: 'new_name', cpf: '00011122', birth_date: '2020-02-02' } }
        let(:person) { create(:person) }

        it 'returns http status not_found' do
          person
          patch v1_person_path('invalid'), params: { person: person_params }
          expect(response).to have_http_status(:not_found)
        end

        it 'does not change db data' do
          person
          expect do
            patch v1_person_path('invalid'), params: { person: person_params }
            person.reload
          end.not_to change { person }
        end

        it 'returns error message' do
          person
          patch v1_person_path('invalid'), params: { person: person_params }
          expect(response.body).to eq({ errors: [{ message: "Couldn't find Person with 'id'=invalid" }] }.to_json)
        end
      end

      describe 'invalid params' do
        let(:person_invalid_params) { { name: '', cpf: '', birth_date: '' } }
        let(:person) { create(:person) }
        subject { patch v1_person_path(person), params: { person: person_invalid_params } }

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
        expected = { id: 1, name: 'LuckGuy', cpf: '999.666.999-66', birth_date: '2022-03-21' }

        delete v1_person_path(person.id)
        expect(response.body).to eq(expected.to_json)
      end

      it 'changes record parameter to deleted: true' do
        delete v1_person_path(person.id)
        person.reload
        expect(person.discarded_at).not_to be nil
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
