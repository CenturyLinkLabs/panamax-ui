Rails.application.routes.draw do
  root 'search#new'

  resource :search, only: [:new, :show], controller: 'search' do
    get 'load_tags', on: :collection
  end

  resources :dashboard, only: [:index]

  resources :templates, only: [:new, :create] do
    member do
      get 'details'
    end
  end

  resources :images, only: [:index, :destroy] do
    collection do
      delete 'destroy_multiple'
    end
  end

  resources :template_repos, only: [:index, :create, :destroy] do
    member do
      post 'reload'
    end
  end

  resource :user, only: [:update]

  resources :apps, only: [:index, :create, :show, :update, :destroy] do
    member do
      get 'documentation'
      get 'journal'
      get 'relations'
      put 'rebuild'
      post 'template'
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

  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unacceptable'
  get '/500', to: 'errors#internal_error'

  mount CtlBaseUi::Engine => '/ctl-base-ui'
end
