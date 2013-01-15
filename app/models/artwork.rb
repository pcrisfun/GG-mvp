class Artwork < ActiveRecord::Base
  attr_accessible :portfolio_id, :event_id, :category, :material, :title, :year, :image, :image_cache
  belongs_to :portfolio
  has_and_belongs_to_many :events
  before_destroy {|artwork| artwork.events.clear}
  mount_uploader :image, ImageUploader

  before_create :default_name
  
  def default_name
    self.title ||= File.basename(image.filename, '.*').titleize if image
  end
end
