WhenDoYouCome::Application.routes.draw do

  root :to => "trackings#index"

  get '/trackings/cancel_route', to: 'trackings#cancel_route'
  get '/trackings/:id', to: 'trackings#show'



  resources :locations do
    get 'get_updated_position'
  end

  resource :trackings do
    post 'init_route'
    post 'update_position'
  end


end
