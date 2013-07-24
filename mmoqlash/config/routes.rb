Rails.application.routes.draw do
  resources :question_answers
  resources :questions
  resources :players
  resources :rooms do
    post "start_game"
    get "check_status"
  end

  get "join", controller: "players", action: "new"

  get "play/:room_id/:player_id", controller: "rooms", action: "play"

  root to: "home#index"
end
