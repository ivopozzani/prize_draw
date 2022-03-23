# frozen_string_literal: true

class Person < ApplicationRecord
  validates :name, :cpf, presence: true
  validates :cpf, uniqueness: true
  validates :drawn, inclusion: { in: [true, false] }

  scope :random, -> { order(Arel.sql('RANDOM()')) }
  scope :drawn, -> { where(drawn: true) }
  scope :not_drawn, -> { where(drawn: false) }
  scope :not_deleted, -> { where(deleted: false) }
end
