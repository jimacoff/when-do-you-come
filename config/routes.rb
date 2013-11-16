WhenDoYouCome::Application.routes.draw do

  root :to => "trackings#index"

  resources :locations

  resource :trackings do
    member do
      post 'init_route'
      get 'update_position'
    end
  end


end
