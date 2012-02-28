class OrderedWord < ActiveRecord::Base
  belongs_to :word
  belongs_to :phrase
end

