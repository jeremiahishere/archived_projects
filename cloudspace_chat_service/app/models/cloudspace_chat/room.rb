class CloudspaceChat::Room < ActiveRecord::Base
	has_many :current_room_users
	validates_presence_of :name
	validates_inclusion_of :public, :in => [true, false]
end
