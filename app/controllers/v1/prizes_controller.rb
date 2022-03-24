# frozen_string_literal: true

module V1
  class PrizesController < ApplicationController
    before_action :authenticate

    def create
      @lucky_person = Person.random.not_drawn.kept.first
      raise "There's no elegible person for this prize drawn" if @lucky_person.nil?

      @lucky_person.update_columns(drawn_at: Time.now)

      render json: @lucky_person, status: :ok, serializer: V1::PrizeSerializer
    end
  end
end
