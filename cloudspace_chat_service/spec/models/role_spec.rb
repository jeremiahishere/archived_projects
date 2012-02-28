require 'spec_helper'

describe CloudspaceChat::Role do
  before  { @role = CloudspaceChat::Role.new }
  subject { @role }

  it { should have_many :room_user_roles }

  it { should respond_to :name }

  it { should validate_presence_of :name }

end
