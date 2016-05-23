Rails.application.routes.draw do
  get 'call_routing/dial'
  get 'call_routing/screen'
  get 'call_routing/connect'

  post 'call_routing/dial'
  post 'call_routing/screen'
  post 'call_routing/connect'

  get 'number_pool/create'
  get 'number_pool/destroy'
  get 'number_pool/index'

  get 'voice/connect'
  post 'voice/connect'

  get 'sms/connect'
  post 'sms/connect'

  get 'reservation/create'
  post 'reservation/create'

  get 'reservation/destroy'
  post 'reservation/destroy'

  get 'reservation/index'
end
