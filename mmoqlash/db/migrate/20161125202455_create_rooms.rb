class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :host
      t.string :code
      t.boolean :active

      t.timestamps
    end
  end
end
