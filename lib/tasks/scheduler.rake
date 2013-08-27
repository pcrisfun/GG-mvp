#will need to be scheduled using the Heroku Scheduler tool when we deploy (schedule for each evening)

namespace :scheduler do
  desc "TODO"
  task :daily_actions => :environment do
    Apprenticeship.complete_apprenticeship
    Workshop.complete_workshop
    #Workshop.cancel_workshop
    Workshop.maker_reminder
    Workshop.maker_followup
    AppSignup.reminder
    AppSignup.followup
    AppSignup.followup_maker
    WorkSignup.first_reminder
    WorkSignup.second_reminder
    WorkSignup.followup
  end
end
