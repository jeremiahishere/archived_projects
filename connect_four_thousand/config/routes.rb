ConnectFourThousand::Application.routes.draw do
  devise_for :users
  resources :users

  resources :games
  
  match "t/:token" => "game_tokens#process_token", :as => "process_access_token"
  match "access_token/:game_id/show", :to => "game_tokens#generate_show_token", :as => "generate_show_access_token"
  match "access_token/:game_id/edit", :to => "game_tokens#generate_edit_token", :as => "generate_edit_access_token"

  root :to => "pages#index"
end
