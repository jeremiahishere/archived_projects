class CreateWebsitePages < ActiveRecord::Migration
  def self.up
    create_table :website_pages do |t|
      t.string :name
      t.string :url
      t.text :summary

      t.timestamps
    end
  end

  def self.down
    drop_table :website_pages
  end
end
