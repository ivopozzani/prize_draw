# frozen_string_literal: true

class Person < ApplicationRecord
  validates :name, :cpf, presence: true
  validates :cpf, uniqueness: true
end
