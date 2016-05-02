class VoiceController < ApplicationController
  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def connect
    t = TwilioNumber.find_by_number(params['To'])
    fail && return if t.blank? || !t.assigned || t.reservation.external_numbers.include?(params['From'])

    response = Twilio::TwiML::Response.new do |r|
      r.Dial callerId: t.number do |d|
        t.reservation.driver_number.number.to_s
      end
    end

    render_twiml response
  end

  private

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
