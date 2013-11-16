WhenDoYouCome::Application.routes.draw do

  root :to => "trackings#index"

  get '/trackings/:id', to: 'trackings#show'

  resources :locations

  resource :trackings do
    post 'init_route'
    get 'update_position'
  end


end
