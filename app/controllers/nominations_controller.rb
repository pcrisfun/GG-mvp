# app/controllers/nominations_controller.rb

class NominationsController < ApplicationController

  def create
    @nomination = Nomination.new(params[:nomination])
    if @nomination.deliver
      redirect_to nominate_path, flash: { success: "Holla! Thanks for nominating a friend to be a Maker! We'll send her a note to see if she's interested :-)" }
    else
      render 'static_pages/nominate'
    end
  end

end