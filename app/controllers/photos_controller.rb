class PhotosController < ApplicationController
  before_filter :load_user_gallery
  # GET /photos
  # GET /photos.json
  def index
    @photos = @gallery.photos
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html #show.html.erb
      format.json { render json: @photo }
    end
  end

  # GET /photos/new
  # GET /photos/new.json
  def new
    @photo = @gallery.photos.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @photo }
    end
  end

  # GET /photos/1/edit
  def edit
    @photo = @gallery.photos.find(params[:id])
  end

  # POST /photos
  # POST /photos.json
  def create
    if params[:album_id]
      @album = Album.find(params[:album_id])
    else
      @album = nil
    end
    @photo = @gallery.photos.create(params[:photo])

    #if @photo.save
    #  respond_to do |format|
    #    format.html {redirect_back_or photo_path(@photo), notice: 'Photo was successfully created.'}
    #    @photos = [@photo]
    #    format.json {render 'index'}
    #  end
    #else
    #  render 'new'
    #end

    # respond_to do |format|
    #   if @photo.save
    #     format.html { redirect_to @gallery, notice: 'Photo was successfully created.' }
    #     format.json { render json: @photo, status: :created, location: gallery_photo_url(@gallery, @photo)}
    #     # format.json {status: :created}
    #   else
    #     format.html { render action: "new" }
    #     format.json { render json: @photo.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PUT /photos/1
  # PUT /photos/1.json
  def update
    @photo = @gallery.photos.find(params[:id])

    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        format.html { redirect_back_or photo_path(@photo), notice: 'Photo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    if params[:album_id]
      @album = Album.find(params[:album_id])
    end
    @photo = @gallery.photos.find(params[:id])
    @photo.file.clear
    @photo = @photo.destroy

    respond_to do |format|
      format.html { redirect_to :back, notice: 'Image was deleted.' }
      format.json { head :no_content }
      format.js
    end
  end

  def sort
    if params[:album_id] && params[:album_photo]
      params[:album_photo].each_with_index do |photo_id, index|
        Photo.find(photo_id).set_position(album_id: params[:album_id], position: index+1)
      end
    end
    render nothing: true
  end

  private
    def load_user_gallery
      @user = current_user
      @gallery = @user.gallery
    end
end
