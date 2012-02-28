class CloudspaceChat::Role < ActiveRecord::Base
	has_many :room_user_roles
	validates_presence_of :name
end
