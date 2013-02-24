scheduler = Rufus::Scheduler.start_new

scheduler.cron '0 22 * * *' do
	Apprenticeship.complete_apprenticeship
end 

scheduler.cron '0 22 * * *' do
	Workshop.complete_workshop
end
