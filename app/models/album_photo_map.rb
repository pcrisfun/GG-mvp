class AlbumPhotoMap < ActiveRecord::Base
  belongs_to :album, inverse_of: :album_photo_maps
  belongs_to :photo, inverse_of: :album_photo_maps

  attr_accessible :album_id, :photo_id

  # position is used to save each photos place in the ablum
  # Photo.position(album_id) should grab this value
  attr_accessible :position

  # each album will have one featured photo
  # Album.featured should return the photo with featured == true
  attr_accessible :featured

  after_create :generate_defaults
  # Use current time to create a position at the end of the list
  def generate_defaults
    self.position = Time.now.to_i
    self.featured = false
    self.save
  end

  # Use set_position action with params: album_id, photo_id, and position
  def set_position(args = {})
    if args[:position]
      self.position = args[:position].to_i
    end
    self.save
  end

  # For use by albums when they set or update their featured photo
  def toggle_featured
    self.featured = !self.featured
    self.save
  end

end
