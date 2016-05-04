class TwilioNumber < ActiveRecord::Base
  validates_uniqueness_of :number

  has_one :reservation, dependent: :destroy
end
