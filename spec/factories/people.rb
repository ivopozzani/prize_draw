# frozen_string_literal: true

FactoryBot.define do
  factory :person do
    name { 'LuckGuy' }
    cpf { '999.666.999-66' }
    birth_date { '2022-03-21' }
    drawn { false }
    deleted { false }
    drawn_date { nil }
  end
end
