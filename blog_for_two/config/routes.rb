BlogForTwo::Application.routes.draw do
  devise_for :users

  resources :posts
  resources :events
  resources :users

  root :to => "pages#index"
end
