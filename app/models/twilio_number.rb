class TwilioNumber < ActiveRecord::Base
  has_one :reservation, dependent: :destroy
end
