Rails.application.routes.draw do
  root 'search#new'

  resource :search, only: [:new, :show], controller: 'search'

  resources :applications, only: [:create, :show]

  mount CtlBaseUi::Engine => "/ctl-base-ui"
end
