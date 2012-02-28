require 'spec_helper'

describe CloudspaceChat::Room do
  before  { @room = CloudspaceChat::Room.new }
  subject { @room }

  it { should have_many :current_room_users }

  it { should respond_to :name }
  it { should respond_to :public }

  it { should validate_presence_of :name }

	it "should validate public is true or false" do
		@room.public = true
		should have(0).errors_on :public

		@room.public = false 
		should have(0).errors_on :public
	end

end
