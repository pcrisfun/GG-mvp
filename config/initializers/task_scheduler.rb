scheduler = Rufus::Scheduler.start_new

scheduler.cron '0 22 * * *' do
	Apprenticeship.complete_apprenticeship
  AppSignup.complete_app_signup
  Workshop.complete_workshop
  WorkSignup.complete_work_signup
end

