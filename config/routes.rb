Rails.application.routes.draw do
  root 'search#new'

  resource :search, only: [:new, :show], controller: 'search' do
    get 'load_tags', on: :collection
  end

  resources :templates, only: [:new, :create]

  resource :user, only: [:update]

  resources :apps, only: [:index, :create, :show, :update, :destroy] do
    member do
      get 'documentation'
      get 'journal'
      get 'relations'
      put 'rebuild'
    end
    collection do
      get :new_from_template
      post :create_from_template
    end
    resources :services, only: [:index, :update, :create, :show, :destroy] do
      get 'journal', on: :member
    end
    resources :categories, only: [:update, :create, :destroy] do
      put 'remove_service', on: :member
      post 'add_service', on: :member
    end
  end

  resources :host_health, only: [:index]

  mount CtlBaseUi::Engine => '/ctl-base-ui'
end
