require 'spec_helper'

describe CloudspaceChat::CurrentRoomUser do
  before  { @current_room_user = CloudspaceChat::CurrentRoomUser.new }
  subject { @current_room_user }

  it { should have_many :messages }
  it { should have_many :room_user_roles }
  it { should have_many(:roles).through(:room_user_roles) }
  it { should belong_to :room }
  it { should belong_to :user }

  it { should respond_to :connected }
  it { should respond_to :allowed }
  it { should respond_to :banned }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :room_id }

	it "should validate connected is true or false" do
		@current_room_user.connected = true
		should have(0).errors_on :connected

		@current_room_user.connected = false 
		should have(0).errors_on :connected
	end

	it "should validate allowed is true or false" do
		@current_room_user.allowed = true
		should have(0).errors_on :allowed

		@current_room_user.allowed = false 
		should have(0).errors_on :allowed
	end

	it "should validate banned is true or false" do
		@current_room_user.banned = true
		should have(0).errors_on :banned

		@current_room_user.banned = false 
		should have(0).errors_on :banned
	end

  it { should respond_to :connect_and_generate_hash }
  describe "connect and generate hash" do
    before(:each) do
      attributes = {
        :room_id => 1,
        :user_id => 2,
        :connected => false,
        :banned => false,
        :allowed => true
      }
      @room_user = CloudspaceChat::CurrentRoomUser.create(attributes)
    end

    it "should generate a hash and set connected" do
      @room_user.connect_and_generate_hash
      @room_user.connected.should be_true
      @room_user.connected_hash.length.should > 0
    end

    it "should not do that if the user is banned" do
      @room_user.banned = true
      @room_user.connect_and_generate_hash
      @room_user.connected.should be_false
      @room_user.connected_hash.should be_nil
    end

    it "should return the value of the connected hash" do
      returned_val = @room_user.connect_and_generate_hash
      @room_user.connected_hash.should == returned_val
    end

    it "should save the user after making changes so it better pass validations" do
      @room_user.should_receive(:save)
      @room_user.connect_and_generate_hash
    end
  end

  it { should respond_to :disconnect_and_remove_hash }
  describe "disconnect_and_remove_hash" do
    before(:each) do
      attributes = {
        :room_id => 1,
        :user_id => 2,
        :connected => true,
        :banned => false,
        :allowed => true
      }
      @room_user = CloudspaceChat::CurrentRoomUser.create(attributes)
    end

    it "should remove the hash and set to disconnected" do
      @room_user.disconnect_and_remove_hash
      @room_user.connected.should be_false
      @room_user.connected_hash.length.should == 0
    end

    it "should save the user after making changes so it better pass validations" do
      @room_user.should_receive(:save)
      @room_user.disconnect_and_remove_hash
    end
  end
end
