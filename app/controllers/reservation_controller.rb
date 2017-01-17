class ReservationController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:edit]

  def index
    render text: Reservation.all.to_json
  end

  def create
    p_num = pool_number
    fail && return unless required_params?
    fail if p_num.blank?
    p_num.assigned = true

    res = Reservation.new(number: params['number'])
    res.build_driver_number(number: clean_number(params['driver_number']))
    res.external_numbers << ExternalNumber.new(number: clean_number(params['external_number']))

    p_num.reservation = res
    p_num.save
    succeed(p_num.number)
  rescue
    fail
  end

  def edit
    res = Reservation.find_by_number(params['res_num'])
    fail && return unless res
    res.driver_number.number = params['driver_number']
    res.driver_number.save
    succeed(res.driver_number.number)
  end

  def destroy
    Reservation.find_by_number(params['number']).destroy
    succeed
  rescue
    fail
  end

  private

  def pool_number
    TwilioNumber.where("assigned = ? or assigned is null", false).order(:updated_at).first
  end

  def clean_number(number)
    stripped = number.tr('^0-9', '')
    return "+1#{stripped}" unless stripped.start_with?('1')
    "+#{stripped}"
  end

  def fail(msg='FAIL')
    response = { status: 'FAIL', number: '' }
    render json: response, status: :unprocessable_entity
  end

  def succeed(number)
    response = { status: 'OK', number: number }
    render json: response, status: :created
  end

  def required_params(action)
    case action
      when 'create'
        p =%w(number external_number driver_number)
    end
  end

  def required_params?
    p = required_params('create')
    return false if p.map { |k| params[k].blank? }.any?
    true
  end
end
