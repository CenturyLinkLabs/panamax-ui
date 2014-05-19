Rails.application.routes.draw do
  root 'search#new'

  resource :search, only: [:new, :show], controller: 'search'

  resources :applications, only: [:index, :create, :show, :destroy] do
    get 'documentation', on: :member
    resources :services, only: [:update, :create, :show, :destroy] do
      get 'journal', on: :member
    end
  end

  mount CtlBaseUi::Engine => "/ctl-base-ui"
end
