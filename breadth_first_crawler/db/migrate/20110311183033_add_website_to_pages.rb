class AddWebsiteToPages < ActiveRecord::Migration
  def self.up
    add_column :website_pages, :website_id, :integer
  end

  def self.down
    remove_column :website_pages, :website_id
  end
end
