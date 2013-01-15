class Artwork < ActiveRecord::Base
  attr_accessible :portfolio_id, :event_id, :category, :material, :title, :year, :image
  belongs_to :portfolio
  has_and_belongs_to_many :events
  mount_uploader :image, ImageUploader
end
