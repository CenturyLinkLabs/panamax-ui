PanamaxUi::Application.routes.draw do
  root 'search#new'

  resource :search, only: [:new, :show]
end
