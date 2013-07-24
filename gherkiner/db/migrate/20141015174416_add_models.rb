class AddModels < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :path

      t.timestamps
    end

    create_table :features do |t|
      t.integer :project_id
      t.string :path
      t.string :contents

      t.timestamps
    end
  end
end
