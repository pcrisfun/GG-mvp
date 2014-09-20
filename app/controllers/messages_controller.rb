class MessagesController < ApplicationController
  def create
    @message =  Message.new(params[:message])
    @message.user_id = current_user.id
    if params[:interview_id]
      @message.interview_id = params[:interview_id]
    end

    respond_to do |format|
      if @message.save
        if @message.interview_id
          @message.interview.deliver_new_message(@message)
        end
        format.html { redirect_to :back, notice: 'Nice! Your message was sent via email' }
        format.json { render json: @message, status: :created, location: @message }
      else
        format.html { redirect_to :back, notice: @message.errors}
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to :back, notice: 'Message was deleted.' }
      format.json { head :no_content }
    end
  end
end
