class Album < ActiveRecord::Base
  attr_accessible :description, :title, :photos_attributes, :limit
  validates_presence_of :title

  has_many :photos, through: :album_photo_maps
  has_many :album_photo_maps, inverse_of: :album, dependent: :destroy

  def add_photo (args = {})
    @photo = args[:photo]
    if @photo
    	unless self.photos.include?(@photo)
    		self.photos<<@photo
    	end
      return true
    end
    return false
  end

  def remove_photo (args = {})
    @photo = args[:photo]
    if @photo
      if self.photos.include?(@photo)
  		  self.photos.delete(@photo)
        return true
      end
    end
    return false
  end

  def featured_photo
    @featured_map = self.album_photo_maps.where(featured: true).first
    if @featured_map
      return @featured_map.photo
    end
    return nil
  end

  def set_featured (args = {})
    @photo = args[:photo]
    if @photo
      # reset the previous featured_photo
      if self.featured_photo
        @old_featured = self.album_photo_maps.where(featured: true).first
        @old_featured.toggle_featured
      end
      # set the new featured_photo
      @new_featured = @photo.album_photo_maps.where(album_id: self.id).first
      if @new_featured
        @new_featured.toggle_featured
        return true
      end
    end
    return false
  end

end
