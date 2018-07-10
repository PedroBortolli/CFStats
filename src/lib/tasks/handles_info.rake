namespace :handles_info do
	desc "TODO"
	task update: :environment do
		include Updater
		update_multiple
	end
end
