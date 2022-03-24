# frozen_string_literal: true

module V1
  class PrizeSerializer < ActiveModel::Serializer
    attributes :name, :cpf, :drawn_at
  end
end
