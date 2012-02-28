class InstallEmailManager < ActiveRecord::Migration
  def self.up
    create_table :managed_emails do |t| 
      t.datetime :date_sent
      t.text :from
      t.text :reply_to
      t.text :to 
      t.text :cc 
      t.text :bcc
      t.text :headers
      t.string :message_id
      t.text :subject
      t.text :body
      t.text :caller

      t.timestamps
    end 
  end 

  def self.down
    drop_table :managed_emails
  end 
end
