class ReservationController < ApplicationController
  def create
    p_num = pool_number
    fail && return unless required_params? && !p_num.blank?
    p_num.assigned = true

    res = Reservation.new(number: params['number'])
    res.build_driver_number(number: params['driver_number'])
    res.external_numbers << ExternalNumber.new(number: params['external_number'])

    p_num.reservation = res
    p_num.save
    succeed
  end

  def destroy
    Reservation.find_by_number(params['number']).destroy
    succeed
  rescue
    fail
  end

  private

  def pool_number
    TwilioNumber.find_by_assigned(false || nil)
  end

  def release_number(twilio_number)
  end

  def fail
    render nothing: true, status: :unprocessable_entity
  end

  def succeed
    render nothing: true, status: :created
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
