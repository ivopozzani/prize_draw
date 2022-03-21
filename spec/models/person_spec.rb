# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Person, type: :model do
  context 'When valid' do
    it 'creates person' do
      expect { create(:person) }.to change(Person, :count).by(1)
    end

    it 'creates many people' do
      expect do
        { Person1: '1111', Person2: '2222', Persont3: '3333', Persont4: '4444' }.each do |name, cpf|
          create(:person, name:, cpf:)
        end
      end.to change(Person, :count).by(4)
    end
  end

  context 'When not valid' do
    it 'does not create person with blank name' do
      expect do
        create(:person, name: nil)
      end.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
    end

    it 'does not create person with blank cpf' do
      expect do
        create(:person, cpf: nil)
      end.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Cpf can't be blank")
    end

    it 'does not create two people on same cpf' do
      expect do
        create(:person, cpf: '1234567')
        create(:person, cpf: '1234567')
      end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Cpf has already been taken')
    end
  end
end
