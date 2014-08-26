class InterviewsController < ApplicationController
  # GET /interviews
  # GET /interviews.json
  before_filter :load_interview

  def load_interview
    if params[:id]
      @interview = Interview.find(params[:id])
      if @interview.app_signup_id
        @app_signup = Signup.find(@interview.app_signup_id)
      end
      if @interview.user_id
        @user = User.find(@interview.user_id)
      end
    end
  end


  def index
    @interviews = Interview.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @interviews }
    end
  end


  # GET /interviews/1
  # GET /interviews/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @interview }
    end
  end


  # GET /interviews/new
  # GET /interviews/new.json
  def new
    @interview = Interview.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @interview }
    end
  end


  # GET /interviews/1/edit
  def edit
  end


  # POST /interviews
  # POST /interviews.json
  def create
    @interview = Interview.new(params[:interview])
    @interview.user_id = current_user.id

    # Debug in load_app_signup in app_signups_controller.rb // need to find params id and pass it through
    # @app_signup = Signup.find(14)
    # @app_signup = Signup.find(@interview.app_signup_id)
    @app_signup = Signup.find(params[:app_signup])
    @interview.app_signup_id = @app_signup.id


    if !@interview.interview_location.present?
      @interview.interview_location = @app_signup.interviews.last.interview_location
    end

    respond_to do |format|
      if @interview.save
        if @interview.user_id == @app_signup.event.user.id
          @app_signup.update_attribute(:state, 'interview_requested')
          @interview.deliver_interview_requested_maker && @interview.deliver_interview_requested
        elsif @interview.user_id == @app_signup.user.id
          @app_signup.update_attribute(:state, 'interview_scheduled')
          @interview.deliver_interview_scheduled_maker && @interview.deliver_interview_scheduled
        end
        format.html { redirect_to @app_signup, notice: "Your Interview was successfully created. We've sent you both an email with the time & location." }
        format.json { render json: @app_signup, status: :created, location: @interview }
      else
        format.html { render action: "new" }
        format.json { render json: @interview.errors, status: :unprocessable_entity }
      end
    end
  end


  # PUT /interviews/1
  # PUT /interviews/1.json
  def update
    respond_to do |format|
      if params[:message_button] == "Send Optional Message"
        if @interview.update_attributes(params[:interview])
          # if @interview.user == @app_signup.user
          #   @interview.deliver_interview_message_maker && @interview.deliver_message_sent_by_girl
          #   format.html { redirect_to @app_signup, notice: "Thanks, we've sent your message along!" }
          # elsif @interview.user == @app_signup.event.user
          #   @interview.deliver_interview_message_sent_by_maker && @interview.deliver_interview_message
          #   format.html { redirect_to @app_signup, notice: "Thanks, we've sent your message along!" }
          # end
        end
      elsif @interview.update_attributes(params[:interview])
        @interview.deliver_interview_rescheduled_maker && @interview.deliver_interview_rescheduled
        format.html { redirect_to @app_signup, notice: "Your Interview was successfully updated. We've sent you both an email with the new time & location." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @interview.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /interviews/1
  # DELETE /interviews/1.json
  def destroy
    @interview = Interview.find(params[:id])
    @interview.destroy

    respond_to do |format|
      format.html { redirect_to interviews_url }
      format.json { head :no_content }
    end
  end
end
