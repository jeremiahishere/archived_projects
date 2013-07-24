class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :public, :default => false

      t.timestamps
    end

    create_table :posts do |t|
      t.integer :event_id
      t.integer :writer_id
      t.text :post

      t.timestamps
    end
  end
end
