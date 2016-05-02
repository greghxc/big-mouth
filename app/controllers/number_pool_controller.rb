class NumberPoolController < ApplicationController
  def create
    TwilioNumber.create(number: params['number'])
    render text: 'ok'
  end

  def destroy
    TwilioNumber.destroy(number: params['number'])
    render text: 'ok'
  end
end
