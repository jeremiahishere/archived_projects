class GamePermission < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  validates_presence_of :game_id, :user_id, :permission_level
end

