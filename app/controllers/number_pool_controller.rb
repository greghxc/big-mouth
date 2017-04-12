class NumberPoolController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:destroy, :create]

  def index
    render json: TwilioNumber.all.to_json
  end

  def create
    tn = TwilioNumber.create(number: params['number'])
    succeed(:created) && return
  end

  def show
    tn = TwilioNumber.find(params['id'])
    fail('Pool number not found') && return unless tn
    tn.assigned = tn.assigned || false
    render json: tn.to_json
  end

  def destroy
    tn = TwilioNumber.find(params['id'])
    fail('Pool number not found') && return unless tn
    tn.destroy
    succeed(:no_content) && return
  end

  private

  def fail(msg = 'FAIL')
    response = { status: 'FAIL', message: msg }
    render json: response, status: :unprocessable_entity
  end

  def succeed(status = :created)
    response = { status: 'OK' }
    render json: response, status: status
  end
end
