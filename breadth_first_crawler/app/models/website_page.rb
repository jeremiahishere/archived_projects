class WebsitePage < ActiveRecord::Base
  has_many :phrases
  belongs_to :website
end
