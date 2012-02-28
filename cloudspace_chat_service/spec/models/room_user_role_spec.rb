require 'spec_helper'

describe CloudspaceChat::RoomUserRole do
  before  { @room_user_role = CloudspaceChat::RoomUserRole.new }
  subject { @room_user_role }

  it { should belong_to :current_room_user }
  it { should belong_to :role }

  it { should validate_presence_of :current_room_user_id }
  it { should validate_presence_of :role_id }

end
