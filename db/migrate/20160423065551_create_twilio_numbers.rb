class CreateTwilioNumbers < ActiveRecord::Migration
  def change
    create_table :twilio_numbers do |t|
      t.string :number
      t.boolean :assigned
      t.timestamps null: false
    end
  end
end
