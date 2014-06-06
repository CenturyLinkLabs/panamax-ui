Rails.application.routes.draw do
  root 'search#new'

  resource :search, only: [:new, :show], controller: 'search' do
    get 'load_tags', on: :collection
  end

  resources :templates, only: [:new]

  resource :user, only: [:update]

  resources :applications, only: [:index, :create, :show, :destroy] do
    get 'documentation', on: :member
    get 'journal', on: :member
    get 'relations', on: :member
    resources :services, only: [:update, :create, :show, :destroy] do
      get 'journal', on: :member
    end
    resources :categories, only: [:update, :create, :destroy]
  end

  mount CtlBaseUi::Engine => "/ctl-base-ui"
end
