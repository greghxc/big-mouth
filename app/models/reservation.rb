class Reservation < ActiveRecord::Base
  has_one :driver_number, dependent: :destroy
  has_many :external_numbers, dependent: :destroy
  belongs_to :twilio_number

  before_destroy :release_number

  private

  def release_number
    twilio_number.assigned = false
    twilio_number.save
  rescue
    logger.error 'Unable to release number.'
  end
end
