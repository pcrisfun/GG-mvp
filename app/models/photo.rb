class Photo < ActiveRecord::Base
	has_and_belongs_to_many :albums

  attr_accessible :caption, :file
  has_attached_file :file, styles: {thumb: "50x50#", medium: "350x240>"}

  def add_album (album)
		if !self.albums.include?(album)
			self.albums<<album
		end
  end

  def remove_album (album)
    if self.albums.include?(album)
		  self.albums.delete(album)
    end
  end

end
