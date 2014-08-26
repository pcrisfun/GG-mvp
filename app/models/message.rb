class Message < ActiveRecord::Base
  attr_accessible :message_text, :user, :interview_id

  def user
    user_id ? User.find(user_id) : nil
  end

  def interview
    interview_id ? Interview.find(interview_id) : nil
  end

end
