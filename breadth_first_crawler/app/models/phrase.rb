class Phrase < ActiveRecord::Base
  has_many :ordered_words
  belongs_to :website_page

  #TODO: add equality operator
end

