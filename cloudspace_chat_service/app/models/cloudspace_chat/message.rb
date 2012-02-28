class CloudspaceChat::Message < ActiveRecord::Base
	belongs_to :current_room_user

  before_validation :prepare_input_text

  validates_presence_of :current_room_user_id, :input_text, :output_text
  validates_inclusion_of :visible, :in => [true, false]

  scope :created_after, lambda { |created_at| where(["cloudspace_chat_messages.created_at > ?", created_at]) }

  # this function should be observed by gems that alter the state of the output text
  # this is the base case
  # input is copied to output without any changes and set to visible
  def prepare_input_text 
    self.output_text = self.input_text
    self.visible = true
  end
end
