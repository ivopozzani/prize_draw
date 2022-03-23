# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Person, type: :model do
  subject { create(:person) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:cpf) }

    it { is_expected.to validate_inclusion_of(:drawn).in_array([true, false]) }
    it { is_expected.to validate_inclusion_of(:deleted).in_array([true, false]) }

    it { is_expected.to validate_uniqueness_of(:cpf).case_insensitive }
  end

  describe 'scopes' do
    let!(:person) { create(:person) }

    describe '.random' do
      subject { described_class.random }

      it { is_expected.to include(person) }
    end

    describe '.drawn' do
      subject { described_class.drawn }

      it { is_expected.not_to include(person) }
    end

    describe '.not_drawn' do
      subject { described_class.not_drawn }

      it { is_expected.to include(person) }
    end

    describe '.not_deleted' do
      subject { described_class.not_deleted }

      it { is_expected.to include(person) }
    end
  end
end
