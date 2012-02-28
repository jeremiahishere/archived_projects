class AddPageToPhrases < ActiveRecord::Migration
  def self.up
    add_column :phrases, :website_page_id, :integer
  end

  def self.down
    remove_column :phrases, :website_page_id
  end
end
