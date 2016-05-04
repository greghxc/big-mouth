class NumberPoolController < ApplicationController
  def index
    render json: TwilioNumber.all.to_json
  end

  def create
    TwilioNumber.create(number: params['number'])
    render text: 'ok'
  end

  def destroy
    TwilioNumber.destroy(number: params['number'])
    render text: 'ok'
  end
end
