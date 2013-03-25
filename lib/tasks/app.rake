#will need to be scheduled using the Heroku Scheduler tool when we deploy

namespace :app do
  desc "TODO"
  task :daily_actions => :environment do
    Apprenticeship.complete_apprenticeship
    Workshop.complete_workshop
    Workshop.cancel_workshop
  end
end
