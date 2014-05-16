class Photo < ActiveRecord::Base
  has_many :albums, through: :album_photo_map
  has_many :album_photo_maps, inverse_of: :photo, dependent: :destroy

  attr_accessible :caption, :file, :protected
  has_attached_file :file, styles: {thumb: "50x50#", box: "135x135#", medium: "270", large: "400x400#" }

  before_create :default_caption

  def default_caption
    self.caption ||= self.file_file_name if file
  end

  def position(args = {})
    if args[:album_id]
      @album_photo_map = self.album_photo_maps.where("album_id = ?", args[:album_id].to_i)
      if @album_photo_map
        return @album_photo_map.first.position
      end
    end
    return false
  end

  def set_position(args = {})
    @album_photo_map = self.album_photo_maps.where("album_id = ?", args[:album_id].to_i)
    if @album_photo_map && args[:position]
      return @album_photo_map.first.set_position(position: args[:position])
    end
    return false
  end

end
