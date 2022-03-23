# frozen_string_literal: true

class AddDrawnDeletedDateColumnsToPeople < ActiveRecord::Migration[7.0]
  def change
    add_column(:people, :drawn, :boolean, null: false, default: false)
    add_column(:people, :deleted, :boolean, null: false, default: false)
    add_column(:people, :drawn_date, :date)
  end
end
