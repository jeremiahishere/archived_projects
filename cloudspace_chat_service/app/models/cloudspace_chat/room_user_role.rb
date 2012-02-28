class CloudspaceChat::RoomUserRole < ActiveRecord::Base
  belongs_to :current_room_user
  belongs_to :role

  validates_presence_of :current_room_user_id, :role_id
end
