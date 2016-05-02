class CreateDriverNumbers < ActiveRecord::Migration
  def change
    create_table :driver_numbers do |t|
      t.string 'number'
      t.integer 'reservation_id'
      t.timestamps null: false
    end
  end
end
