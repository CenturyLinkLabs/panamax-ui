PanamaxUi::Application.routes.draw do
  root 'search#new'

  resource :search, only: [:new, :show], controller: 'search'

  mount CtlBaseUi::Engine => "/ctl-base-ui"
end
