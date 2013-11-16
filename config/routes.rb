WhenDoYouCome::Application.routes.draw do

  root :to => "tracking#index"

  resources :location

  resource :tracking do
    member do
      get 'init_route'
      get 'update_position'
    end
  end


end
