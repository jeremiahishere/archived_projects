class Word < ActiveRecord::Base
  has_many :ordered_words
end
