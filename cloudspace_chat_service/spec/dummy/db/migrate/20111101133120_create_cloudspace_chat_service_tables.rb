class CreateCloudspaceChatServiceTables < ActiveRecord::Migration
  def self.up
    create_table :cloudspace_chat_current_room_users do |t|
      t.integer :user_id, :null => false
      t.integer :room_id, :null => false
      t.boolean :connected
      t.string :connected_hash
      t.boolean :allowed
      t.boolean :banned

      t.timestamps
    end

    create_table :cloudspace_chat_messages do |t|
      t.integer :current_room_user_id, :null => false
      t.text :input_text, :null => false
      t.text :output_text, :null => false
      t.boolean :visible

      t.timestamps
    end

    create_table :cloudspace_chat_room_user_roles do |t|
      t.integer :current_room_user_id, :null => false
      t.integer :role_id, :null => false

      t.timestamps
    end

    create_table :cloudspace_chat_rooms do |t|
      t.string :name, :null => false
      t.boolean :public

      t.timestamps
    end

    create_table :cloudspace_chat_roles do |t|
      t.string :name, :null => false

      t.timestamps
    end
  end
  
  def self.down
    drop_table :cloudspace_chat_current_room_users
    drop_table :cloudspace_chat_messages
    drop_table :cloudspace_chat_room_user_roles
    drop_table :cloudspace_chat_rooms
  end
end

