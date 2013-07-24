class Post < ActiveRecord::Base
  belongs_to :event
  belongs_to :writer, :class_name => "User", :foreign_key => "writer_id"

  validates_presence_of :writer, :post
  validates_presence_of :event, :on => :update
end
