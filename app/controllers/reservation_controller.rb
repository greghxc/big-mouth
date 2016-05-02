class ReservationController < ApplicationController
  def create
    fail && return unless required_params?
    res = Reservation.new(number: params['number'])
    res.build_driver_number(number: params['driver_number'])
    res.external_numbers << ExternalNumber.new(number: params['external_number'])
    res.save
    succeed
  end

  def destroy
  end

  private

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
