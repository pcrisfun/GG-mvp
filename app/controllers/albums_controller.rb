class AlbumsController < ApplicationController
  before_filter :load_user_gallery # , :authenticate_user!
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

    if params[:add_photos]
      params[:add_photos].each do |photo_id|
        photo = Photo.find(photo_id)
        @album.add_photo(photo)
      end
    end
    if params[:remove_photos]
      params[:remove_photos].each do |photo_id|
        photo = Photo.find(photo_id)
        @album.remove_photo(photo)
      end
    end

    respond_to do |format|
      if @album.update_attributes(params[:album])
        format.html { redirect_to album_path(@album) }
        format.json { head :no_content }
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

  private
  def load_user_gallery
    @user = current_user
    @gallery = @user.gallery
  end
end
