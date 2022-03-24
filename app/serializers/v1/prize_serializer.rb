# frozen_string_literal: true

module V1
  class PrizeSerializer < ActiveModel::Serializer
    attributes :name, :cpf, :drawn_at

    def drawn_at
      object.drawn_at.strftime('%F %TH')
    end
  end
end
