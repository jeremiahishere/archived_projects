class CreateOrderedWords < ActiveRecord::Migration
  def self.up
    create_table :ordered_words do |t|
      t.integer :phrase_id
      t.integer :word_id
      t.integer :order_num

      t.timestamps
    end
  end
  def self.down
    drop_table :ordered_words
  end
end
