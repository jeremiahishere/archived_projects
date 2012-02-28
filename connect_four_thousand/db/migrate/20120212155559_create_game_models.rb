class CreateGameModels < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :user_id
      t.string :name
      t.boolean :public
      t.boolean :in_progress, :default => true

      t.timestamps
    end
  end
end
