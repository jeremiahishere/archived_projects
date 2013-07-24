class Event < ActiveRecord::Base
  has_many :posts
  accepts_nested_attributes_for :posts

  validates_presence_of :start_at, :name

  scope :public, lambda { where(:public => true) }
  scope :newest_by_creation, lambda { order("created_at desc") }
  scope :newest_by_start_date, lambda { order("start_at desc") }

  def user_has_posted?(user)
    !user_post(user).nil?
  end

  def user_post(user)
    posts.select { |p| p.writer == user }.first
  end
end
