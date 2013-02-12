namespace :complete do
	desc "Check if workshop dates have passed and if so move them to state :completed"
	task :workshop => :environment do
		Workshop.complete_workshop
	end

	desc "Check if apprenticeship end date has passed and if so move them to state :completed"
	task :apprenticeship => :environment do
		Apprenticeship.complete_apprenticeship
	end

	task :events => [:workshop, :apprenticeship]
end


