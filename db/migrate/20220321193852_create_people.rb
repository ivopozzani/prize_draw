# frozen_string_literal: true

class CreatePeople < ActiveRecord::Migration[7.0]
  def change
    create_table :people do |t|
      t.string :name, null: false
      t.string :cpf, null: false, unique: true
      t.date :birth_date

      t.timestamps
    end
  end
end
