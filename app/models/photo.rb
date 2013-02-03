class Photo < ActiveRecord::Base
	belongs_to :gallery

  attr_accessible :caption, :file
  has_attached_file :file, styles: {thumb: "100x100#", medium: "350x270>"}

end
