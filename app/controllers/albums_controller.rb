class AlbumsController < ApplicationController
  before_filter :load_user_gallery, :authenticate_user!
  # GET /albums
  # GET /albums.json
  def index
    @albums = @gallery.albums.all

    store_location

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @albums }
    end
  end

  # GET /albums/1
  # GET /albums/1.json
  def show
    @albums = @gallery.albums
    @album = Album.find(params[:id])

    store_location

    respond_to do |format|
      format.html # show.html.erb
      format.json { render 'show' }
    end
  end

  # GET /albums/new
  # GET /albums/new.json
  def new
    @album = @gallery.albums.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @album }
    end
  end

  # GET /albums/1/edit
  def edit
    @album = Album.find(params[:id])
  end

  # POST /albums
  # POST /albums.json
  def create
    @album = @gallery.albums.new(params[:album])

    respond_to do |format|
      if @album.save
        format.html { redirect_to album_path(@album) }
        format.json { render json: @album, status: :created, location: @album }
      else
        format.html { render action: "new" }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /albums/1
  # PUT /albums/1.json
  def update
    @album = Album.find(params[:id])

    respond_to do |format|
      if @album.update_attributes(params[:album])
        @albums = @gallery.albums.all
        format.html { redirect_back_or album_path(@album) }
        format.json { render json: @album }
      else
        format.html { render action: "edit" }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.json
  def destroy
    @album = Album.find(params[:id])
    @album.destroy

    respond_to do |format|
      format.html { redirect_to albums_path }
      format.json { head :no_content }
    end
  end

  # POST /albums/add_photos
  def add_photos
    @album = Album.find(params[:id])
    params[:add_photos].each do |photo_id|
      if @album.limit && !(@album.limit > @album.photos.size)
        respond_to do |format|
          format.js { render 'albums/over_limit' and return }
        end
      else
        @photo = Photo.find(photo_id)
        @album.add_photo(photo: @photo)
      end
      if @album.limit && (@album.limit == @album.photos.size)
        respond_to do |format|
          format.js { render 'albums/add_last_photo' and return}
        end
      end
      respond_to do |format|
        format.js { render 'albums/add_photo' and return}
      end
    end
  end

  # POST /albums/remove_photos
  def remove_photos
    @album = Album.find(params[:id])
    params[:add_photos].each do |photo_id|
      @photo = Photo.find(photo_id)
      @album.remove_photo(photo: @photo)
    end
    respond_to do |format|
      format.js { render 'albums/remove_photo' }
    end
  end

  # POST /albums/set_featured
  def set_featured
    @album = Album.find(params[:id])
    @photo = Photo.find(params[:add_featured])
    @old_featured = @album.featured_photo
    @album.set_featured(photo: @photo)
    respond_to do |format|
      format.js { render 'albums/add_featured' }
    end
  end

  private
    def load_user_gallery
      @user = current_user
      @gallery = @user.gallery
    end
end
