class ArtworksController < ApplicationController
  # GET /artworks
  # GET /artworks.json
  # GET /artworks/1
  # GET /artworks/1.json
  # GET /artworks/new
  # GET /artworks/new.json
  def new
    @artwork = Artwork.new(:portfolio_id => params[:portfolio_id])
  end

  # GET /artworks/1/edit
  def edit
    @artwork = Artwork.find(params[:id])
  end

  # POST /artworks
  # POST /artworks.json
  def create
    @artwork = Artwork.new(params[:artwork])
    if @artwork.save
      flash[:notice] = "Successfully uploaded artwork."
      redirect_to @artwork.portfolio
    else
      render :action => 'new'
    end
  end

  # PUT /artworks/1
  # PUT /artworks/1.json
  def update
    @artwork = Artwork.find(params[:id])
    if @artwork.update_attributes(params[:artwork])
      flash[:notice] = "Successfully updated artwork."
      redirect_to @artwork.portfolio
    else
      render :action => 'edit'
    end
  end

  # DELETE /artworks/1
  # DELETE /artworks/1.json
  def destroy
    @artwork = Artwork.find(params[:id])
    @artwork.destroy
    flash[:notice] = "Successfully deleted artwork."
    redirect_to @artwork.portfolio
  end
end
