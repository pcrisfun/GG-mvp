class EventSkillsController < ApplicationController

  def index

    tag_records = Event.tag_counts_on(:skills).where(["#{ActsAsTaggableOn::Tag.table_name}.name LIKE ?", "#{params[:q]}%"])
    tags = tag_records.map { |t|  { :id => t.name, :name => t.name } }

    respond_to do |format|
      format.html { render :json => tags }
      format.json { render :json => tags }
    end
  end

end