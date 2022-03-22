# frozen_string_literal: true

module V1
  class PeopleController < ApplicationController
    def index
      @people = Person.all

      render json: @people, status: :ok, each_serializer: V1::PersonSerializer
    end

    def create
      @person = Person.create!(person_params)

      render json: @person, status: :created, serializer: V1::PersonSerializer
    end

    def update
      @person = Person.find(params[:id])
      @person.update!(person_params)

      render json: @person, status: :ok, serializer: V1::PersonSerializer
    end

    def destroy
      @person = Person.find(params[:id]).destroy!

      render json: @person, status: :ok, serializer: V1::PersonSerializer
    end

    private

    def person_params
      params.require(:person).permit(:name, :cpf, :birth_date)
    end
  end
end
