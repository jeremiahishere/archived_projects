class CreateRoleSystem < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.integer :user_id
      t.string :name

      t.timestamps
    end

    create_table :role_assignments do |t|
      t.integer :role_id
      t.integer :user_id

      t.timestamps
    end
  end
end
