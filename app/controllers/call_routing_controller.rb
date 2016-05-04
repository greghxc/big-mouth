class CallRoutingController < ApplicationController
  after_filter :set_header
  skip_before_action :verify_authenticity_token

  def dial
    @fallback_num = '+12065266087'
    @twilio_num = params['To']

    t = TwilioNumber.find_by_number(@twilio_num)
    fail && return if t.blank? || !t.assigned

    @driver_num = t.reservation.driver_number.number
    @passeger_num = t.reservation.external_numbers.first.number

    fail && return unless params['retry'].blank?
    dial_without_screen(@passeger_num) && return if @driver_num == (params['From'])
    dial_with_screen(@driver_num) && return if @passeger_num.include?(params['From'])
    fail
  end

  def screen
    response = Twilio::TwiML::Response.new do |r|
      r.Gather action: '/call_routing/connect', numDigits: '1', finishOnKey: '' do
        r.Pause length: 1
        r.Say 'Press 1 to accept call from your Aces Client.'
      end
      r.Hangup
    end
    render_twiml response
  end

  def connect
    response = Twilio::TwiML::Response.new do |r|
      r.Pause length: 3
      r.Say 'Connecting now'
    end
    render_twiml response
  end

  private

  def fail
    dial_without_screen(@fallback_num)
  end

  def dial_with_screen(number)
    response = Twilio::TwiML::Response.new do |r|
      r.Play 'http://acestowncarservice.com/calltest/screen/aces_intro_01182015.wav', loop: '1'
      r.Dial callerId: @twilio_num, action: '/call_routing/dial?retry=1' do
        r.Number @driver_num, url: '/call_routing/screen'
      end
    end
    render_twiml response
  end

  def dial_without_screen(number)
    response = Twilio::TwiML::Response.new do |r|
      r.Dial number, callerId: @twilio_num
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
