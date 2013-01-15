class Portfolio < ActiveRecord::Base
  attr_accessible :user_id, :name
  belongs_to :user
  has_many :artworks
end
