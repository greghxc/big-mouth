Rails.application.routes.draw do
  get 'number_pool/create'
  get 'number_pool/destroy'

  get 'voice/connect'
  post 'voice/connect'

  get 'reservation/create'
  post 'reservation/create'

  get 'reservation/destroy'
  post 'reservation/destroy'
end
