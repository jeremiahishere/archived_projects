require 'active_support/secure_random'

class CloudspaceChat::CurrentRoomUser < ActiveRecord::Base
	has_many :messages
	has_many :room_user_roles
  has_many :roles, :through => :room_user_roles
	belongs_to :room
	belongs_to :user

	validates_presence_of :room_id, :user_id
	validates_inclusion_of [:connected, :allowed, :banned], :in => [true, false]

  # sets a user to connected unless banned and gives them a hash for posting
  def connect_and_generate_hash
    unless banned?
      self.connected_hash = ActiveSupport::SecureRandom.base64(16)
      self.connected = true
      self.save
    end
    return self.connected_hash
  end

  # disconnects a user and removes the posting hash
  #
  # only disconnects the backend
  def disconnect_and_remove_hash
    self.connected = false
    self.connected_hash = ""
    self.save
  end
end
