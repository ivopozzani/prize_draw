# frozen_string_literal: true

FactoryBot.define do
  factory :person do
    name { 'MyString' }
    cpf { 'MyString' }
    birth_date { '2022-03-21' }
  end
end
