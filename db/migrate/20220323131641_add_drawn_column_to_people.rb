# frozen_string_literal: true

class AddDrawnColumnToPeople < ActiveRecord::Migration[7.0]
  def change
    add_column(:people, :drawn, :boolean, null: false, default: false)
  end
end
