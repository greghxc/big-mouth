class CallRoutingController < ApplicationController
  after_filter :set_header
  skip_before_action :verify_authenticity_token

  def dial
    t = TwilioNumber.find_by_number(params['To'])
    fail && return if t.blank? || !t.assigned

    driver_number = t.reservation.driver_number.number
    twilio_number = t.number

    response = Twilio::TwiML::Response.new do |r|
      r.Play 'https://acestowncarservice.com/calltest/screen/aces_intro_01182015.wav', loop: '1'
      r.Dial callerId: twilio_number, action: '/call_routing/dial' do
        r.Number driver_number, url: '/call_routing/screen'
      end
    end
    render_twiml response
  end

  def screen
    response = Twilio::TwiML::Response.new do |r|
      r.Gather action: '/call_routing/connect', numDigits: '1', finishOnKey: '' do
        r.Say 'Press any key to accept call from your Aces Client.'
      end
      r.Hangup
    end
    render_twiml response
  end

  def connect
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'Connecting'
    end
    render_twiml response
  end

  private

  def set_header
    response.headers["Content-Type"] = "text/xml"
  end

  def render_twiml(response)
    render text: response.text
  end
end
