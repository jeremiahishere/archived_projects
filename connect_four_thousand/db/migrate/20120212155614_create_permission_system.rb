class CreatePermissionSystem < ActiveRecord::Migration
  def change
    create_table :game_tokens do |t|
      t.integer :game_id
      t.string :token
      t.string :permission_level
      t.datetime :expiration_date

      t.timestamps
    end

    add_index :game_tokens, :token, :unique => true

    create_table :game_permissions do |t|
      t.integer :game_id
      t.integer :user_id
      t.string :permission_level

      t.timestamps
    end
  end
end
