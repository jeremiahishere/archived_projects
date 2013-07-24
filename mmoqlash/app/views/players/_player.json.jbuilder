json.extract! player, :id, :alias, :room_id, :created_at, :updated_at
json.url player_url(player, format: :json)