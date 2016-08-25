class NumberPoolController < ApplicationController
  def index
    render json: TwilioNumber.all.to_json
  end

  def create
    TwilioNumber.create(number: params['number'])
    render text: 'ok'
  end

  def destroy
    tn = TwilioNumber.find_by_number(params['number'])
    raise ActionController::RoutingError.new('Not Found') unless tn
    tn.destroy
    render text: 'ok'
  end
end
