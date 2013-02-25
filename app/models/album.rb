class Album < ActiveRecord::Base
  attr_accessible :description, :title, :photos_attributes
  validates_presence_of :title

  has_and_belongs_to_many :photos

  def add_photo (photo)
		if !self.photos.include?(photo)
			self.photos<<photo
		end
  end

  def remove_photo (photo)
    if self.photos.include?(photo)
		  self.photos.delete(photo)
    end
  end

end
