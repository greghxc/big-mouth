Rails.application.routes.draw do
  # mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get 'call_routing/dial'
  get 'call_routing/screen'
  get 'call_routing/connect'

  post 'call_routing/dial'
  post 'call_routing/screen'
  post 'call_routing/connect'

  get 'number_pool', to: 'number_pool#index'
  post 'number_pool', to: 'number_pool#create'
  get 'number_pool/:id', to: 'number_pool#show'
  delete 'number_pool/:id', to: 'number_pool#destroy'

  get 'voice/connect'
  post 'voice/connect'

  get 'sms/connect'
  post 'sms/connect'

  get 'reservation/create'
  post 'reservation/create'
  post 'reservation', to: 'reservation#create'
  put 'reservation/:res_num', to: 'reservation#edit'
  delete 'reservation/:number', to: 'reservation#destroy'

  get 'reservation/destroy'
  post 'reservation/destroy'

  get 'reservation', to: 'reservation#index'
  get '/api-docs', to: 'docs#index'
end
