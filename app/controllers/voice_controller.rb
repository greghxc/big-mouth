class VoiceController < ApplicationController
  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def connect
    # fail && return if param[''].blank?
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'Hey there. Congrats on integrating Twilio into your Rails 4 app.', :voice => 'alice'
      r.Play 'http://linode.rabasa.com/cantina.mp3'
    end

    render_twiml response
  end

  private

  def fail
    render nothing: true, status: :unprocessable_entity
  end

  def set_header
    response.headers["Content-Type"] = "text/xml"
  end

  def render_twiml(response)
    render text: response.text
  end
end
