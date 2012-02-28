require 'active_support/secure_random'

# a temporary token to allow permissions to be granted to users
class GameToken < ActiveRecord::Base
  belongs_to :game

  before_validation :set_token_and_expiration

  validates_presence_of :game, :token, :expiration_date, :permission_level
  validates_uniqueness_of :token

  def set_token_and_expiration
    # there is an extremely tiny chance there will be a collision here
    self.token = SecureRandom.base64(8)[0..8] unless self.token 
    self.expiration_date = 1.day.from_now unless self.expiration_date
  end

  scope :active_token, lambda { |token| where(["game_tokens.token = ? and game_tokens.expiration_date <= ?", token, Time.now]) }

  def expired?
    self.expiration_date < Time.now
  end
end

