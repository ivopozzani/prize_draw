# frozen_string_literal: true

module V1
  class PersonSerializer < ActiveModel::Serializer
    attributes :id, :name, :cpf, :birth_date
  end
end
