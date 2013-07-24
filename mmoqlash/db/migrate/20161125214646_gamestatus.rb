class Gamestatus < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :status, :string
  end
end
