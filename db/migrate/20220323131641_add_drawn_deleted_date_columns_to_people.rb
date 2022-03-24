# frozen_string_literal: true

class AddDrawnDeletedDateColumnsToPeople < ActiveRecord::Migration[7.0]
  def change
    add_column(:people, :drawn_at, :datetime)
  end
end
