class ReservationController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:edit, :destroy, :create]

  def index
    render text: Reservation.all.to_json(include: [:driver_number, :external_numbers])
  end

  def show
    r = Reservation.find(params[:id])
    fail('Reservation not found') && return if r.blank?
    render text: Reservation.all.to_json(include: [:driver_number, :external_numbers])
  end

  def create
    p_num = pool_number
    fail('Required parameter missing') && return unless required_params?
    fail('No pool numbers available') && return if p_num.blank?
    p_num.assigned = true

    res = Reservation.new(number: params['number'])
    res.build_driver_number(number: clean_number(params['driver_number']))
    res.external_numbers << ExternalNumber.new(number: clean_number(params['external_number']))

    p_num.reservation = res
    p_num.save
    succeed(p_num.number)
  rescue StandardError => e
    fail(e)
  end

  def edit
    res = Reservation.find_by_number(params['res_num'])
    fail('Reservation not found') && return unless res
    fail('Required parameter missing') && return if params['driver_number'].blank?
    res.driver_number.number = params['driver_number']
    res.driver_number.save
    succeed(res.driver_number.number, :ok)
  end

  def destroy
    Reservation.find_by_number(params['number']).destroy
    succeed(params['number'], :no_content)
  rescue StandardError => e
    fail(e)
  end

  private

  def pool_number
    TwilioNumber.where('assigned = ? or assigned is null', false).order(:updated_at).first
  end

  def clean_number(number)
    stripped = number.tr('^0-9', '')
    return "+1#{stripped}" unless stripped.start_with?('1')
    "+#{stripped}"
  end

  def fail(msg = 'FAIL')
    response = { status: 'FAIL', message: msg }
    render json: response, status: :unprocessable_entity
  end

  def succeed(number, status = :created)
    response = { status: 'OK', number: number }
    render json: response, status: status
  end

  def required_params(action)
    case action
    when 'create'
      %w(number external_number driver_number)
    end
  end

  def required_params?
    p = required_params('create')
    return false if p.map { |k| params[k].blank? }.any?
    true
  end
end
