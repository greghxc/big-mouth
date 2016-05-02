class VoiceController < ApplicationController
  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def connect
    t = TwilioNumber.find_by_number(params['To'])
    fail && return if t.blank? || !t.assigned

    to_passenger && return if t.reservation.driver_number == (params['From'])
    to_driver && return if t.reservation.external_numbers.include?(params['From'])
  end

  private

  def to_driver
    forward(t.reservation.external_numbers.first.number.to_s)
  end

  def to_passenger
    forward(t.reservation.driver_number.number.to_s)
  end

  def forward(number)
    response = Twilio::TwiML::Response.new do |r|
      r.Dial number, callerId: t.number
    end

    render_twiml response
  end

  def fail
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'You done messed up.'
    end

    render_twiml response
  end

  def set_header
    response.headers["Content-Type"] = "text/xml"
  end

  def render_twiml(response)
    render text: response.text
  end
end
