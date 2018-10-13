class AddTotalHoursWastedToBlogPosts < ActiveRecord::Migration
  def self.up
    add_column :blog_posts, :total_hours_wasted, :text
  end

  def self.down
    remove_column :blog_posts, :total_hours_wasted
  end
end
