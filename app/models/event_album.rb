class EventAlbum < Album
  # attr_accessible :title, :body
  belongs_to :event
  before_destroy :delete_photos

  def delete_photos
    self.photos.destroy
  end

end
