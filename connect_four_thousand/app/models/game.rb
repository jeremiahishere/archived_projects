# Game of connect 4
#
# created by a user
# can be in progress or ended
# if it is public, bypass the permissions system
# if it is private, require a user token to access the game
class Game < ActiveRecord::Base
  belongs_to :user
  has_many :game_permissions

  has_many :turns

  validates_presence_of :user_id
  validates_presence_of :name
  validates_inclusion_of :in_progress, :in => [true, false]
  validates_inclusion_of :public, :in => [true, false]

  after_create :create_default_permission

  # not sure if this is necessary
  def create_default_permission
    # that is a fun looking method name
    GamePermission.find_or_create_by_game_id_and_user_id(
      :game_id => self.id,
      :user_id => self.user.id,
      :permission_level => "full"
    )
  end

  scope :public_games, lambda { where(:public => true) }

  # get the games the user has permissions for
  # and the public ones
  # this seems sort of messy
  # this could potentially return the same game multiple times
  def self.by_permissions(user)
    GamePermission.where(:user_id => user.id).collect { |p| p.game } | Game.public_games
  end

  # determines if the user has game permissions of the given level
  # this needs to be seriously refactored
  def has_permission?(user, perm_level)
    perm = game_permissions.where(:user_id => user.id).first
    if perm.nil?
      return false
    elsif perm_level == "show"
      if self.public? || perm.permission_level == "show" || perm.permission_level == "edit" || perm.permission_level == "full" 
        return true
      end
    elsif perm_level == "edit"
      if perm.permission_level == "edit" || perm.permission_level == "full" 
        return true
      end
    elsif perm_level == "full"
      if perm.permission_level == "full" 
        return true
      end
    end
    return false
  end
end
