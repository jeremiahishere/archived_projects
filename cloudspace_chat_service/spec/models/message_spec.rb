require 'spec_helper'

describe CloudspaceChat::Message do
  before  { @message = CloudspaceChat::Message.new }
  subject { @message }

  it { should belong_to :current_room_user }

  it { should respond_to :input_text }
  it { should respond_to :output_text }
  it { should respond_to :visible }

  it { should validate_presence_of :current_room_user_id }
  it { should validate_presence_of :input_text }
  it { should validate_presence_of :output_text }

	it "should validate visible is true or false" do
		@message.visible = true
		should have(0).errors_on :visible

		@message.visible = false 
		should have(0).errors_on :visible
	end

  it { should respond_to :prepare_input_text }
  describe ".prepare_input_text" do
    it "should be called before validations" do
      @message.should_receive(:prepare_input_text)
      @message.valid?
    end

    it "should set the output to input and set the message to visible" do
      @message.attributes = { :input_text => "hello", :visible => nil }
      @message.valid?
      @message.output_text.should == "hello"
      @message.visible.should be_true
    end
  end
end
