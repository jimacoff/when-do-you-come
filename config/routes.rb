WhenDoYouCome::Application.routes.draw do

  root :to => "tracking#index"

  resources :location

  resources :tracking do
    get 'init_route'
    get 'update_position'
  end


end
