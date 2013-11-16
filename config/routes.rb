WhenDoYouCome::Application.routes.draw do

  root :to => "tracking#index"

  resources :location


end
