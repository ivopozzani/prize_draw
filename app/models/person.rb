# frozen_string_literal: true

class Person < ApplicationRecord
  validates :name, :cpf, presence: true
  validates :cpf, uniqueness: true

  scope :random, -> { order(Arel.sql('RANDOM()')) }
  scope :drawn, -> { where.not(drawn_at: nil) }
  scope :not_drawn, -> { where(drawn_at: nil) }
end
