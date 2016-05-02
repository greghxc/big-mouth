class Reservation < ActiveRecord::Base
  has_one :driver_number
  has_many :external_numbers
  belongs_to :twilio_number
end
