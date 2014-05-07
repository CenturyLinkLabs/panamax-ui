Rails.application.routes.draw do
  root 'search#new'

  resource :search, only: [:new, :show], controller: 'search'

  resources :applications, only: [:index, :create, :show] do
    resources :services, only: [:update, :create, :show, :destroy]
  end

  mount CtlBaseUi::Engine => "/ctl-base-ui"
end
