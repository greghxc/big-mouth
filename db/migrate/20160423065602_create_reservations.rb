class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.string :number
      t.boolean :active
      t.timestamps null: false
      t.integer :twilio_number_id
    end
  end
end
