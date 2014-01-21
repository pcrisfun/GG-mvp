#will need to be scheduled using the Heroku Scheduler tool when we deploy (schedule for each evening)

#1st, based on end date, complete apprenticeships that were confirmed, and workshops that were accepted w/ minimum # signups
namespace :scheduler do
  desc "TODO"
  task :complete_events => :environment do
    Apprenticeship.complete_apprenticeship
    Workshop.complete_workshop
  end
end

#2nd, based on close registrations date, cancel workshops that don't have minimum # signups
namespace :scheduler do
  desc "TODO"
  task :cancel_events => :environment do
    Workshop.cancel_workshop
  end
end

#3rd, based on start date, send reminders if they haven't been sent yet
namespace :scheduler do
  desc "TODO"
  task :send_reminders => :environment do
    Workshop.maker_reminder
    AppSignup.reminder
    WorkSignup.first_reminder
    WorkSignup.second_reminder
  end
end

#4th, based on end date, send follow up emails if they haven't been sent yet
namespace :scheduler do
  desc "TODO"
  task :send_followups => :environment do
    Workshop.maker_followup
    AppSignup.followup
    AppSignup.followup_maker
    WorkSignup.followup
  end
end

#Henry said what might fix the issues with these is if we separate out the ones that need to run in order into separate tasks (ie. create a task that runs Workshop.complete_workshop THEN runs Workshop.cancel_workshop), then call that task in the task that gets scheduled.

#adding this dumbass comment so I'll have something push to test staging since it randomly crashed. More derp diddly doo

#one more just to test