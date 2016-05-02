class CreateExternalNumbers < ActiveRecord::Migration
  def change
    create_table :external_numbers do |t|
      t.string :number
      t.timestamps null: false
      t.integer :reservation_id
    end
  end
end
