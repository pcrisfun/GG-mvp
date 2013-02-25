class GalleriesController < ApplicationController
  before_filter :load_user
  # GET /galleries
  # GET /galleries.json
  def index
    @gallery = @user.gallery

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gallery }
    end
  end

  # GET /galleries/1
  # GET /galleries/1.json
  def show
    @gallery = @user.gallery

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gallery }
    end
  end

  # GET /galleries/new
  # GET /galleries/new.json
  def new
    @gallery = @user.gallery.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gallery }
    end
  end

  # GET /galleries/1/edit
  def edit
    @gallery = @user.gallery
  end

  # POST /galleries
  # POST /galleries.json
  def create
    @gallery = @user.gallery.new(params[:gallery])

    respond_to do |format|
      if @gallery.save
        format.html { redirect_to galleries_path(@gallery), notice: 'gallery was successfully created.' }
        format.json { render json: @gallery, status: :created, location: galleries_path(@gallery) }
      else
        format.html { render action: "new" }
        format.json { render json: @gallery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /galleries/1
  # PUT /galleries/1.json
  def update
    @gallery = @user.gallery

    respond_to do |format|
      if @gallery.update_attributes(params[:gallery])
        format.html { redirect_to @gallery, notice: 'gallery was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @gallery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /galleries/1
  # DELETE /galleries/1.json
  def destroy
    @gallery = @user.gallery
    @gallery.destroy

    respond_to do |format|
      format.html { redirect_to user_url }
      format.json { head :no_content }
    end
  end

  private
  def load_user
    @user = current_user
  end
end
