class DatabaseController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :authenticate_user!, :except => [:index, :search, :about, :result, :test, :update_handle_info, :cron_update]

	include Api
	include Updater

	def cron_update
		@content = update_multiple
	end


	# Updates handle informations (of /result page) and stores them in database
	def update_handle_info
		handle1 = params[:handle1]
		update_user_info(handle1)
		handle2 = params[:handle2]
		puts("handle2 => " + handle2.to_s)
		if (handle2 != "")
			update_user_info(handle2)
		end
	end

	# Updates (or creates if it doesn't exist) CF handle passed by parameter in database
	def update_handle_to_db
		to_add = params[:name].to_s
		user_exists = false
		@return = false

		if !validate(to_add, "handle")
			render plain: @return.inspect
			return
		end
		
		to_add = validate(to_add, "handle")

		for lines in UserSetting.where(username: current_user.username)
			user_exists = true
			lines.handle = to_add
			lines.save
		end
		if !user_exists
			new_entry = UserSetting.create(:settings => [], :username => current_user.username, :friends => [], :contests => [], :handle => to_add.to_s)
			new_entry.save
		end
		@return = to_add
		render plain: @return
	end

	# Adds problem link passed by parameter to database
	def add_links_to_db
		to_add = params[:name].to_s
		user_exists = false
		@return = false

		if !validate(to_add, "problem")
			render plain: @return.inspect
			return
		end

		for lines in UserSetting.where(username: current_user.username)
			user_exists = true
			all_links = lines.settings
			if !(all_links.include? to_add)
				lines.settings << to_add
				@return = true
				lines.save
			end
		end
		if !user_exists
			new_entry = UserSetting.create(:settings => [to_add], :username => current_user.username, :friends => [], :contests => [], :handle => "")
			new_entry.save
			@return = true
		end
		render plain: @return.inspect
	end

	# Removes problem link passed by parameter from database
	def remove_links_from_db
		to_delete = params[:name].to_s
		@return = false
		for lines in UserSetting.where(username: current_user.username)
			all_links = lines.settings
			if all_links.include? to_delete
				lines.settings.delete(to_delete)
				lines.save
				@return = true
			end
		end
		render plain: @return.inspect
	end

	# Adds friends passed by parameter to database
	def add_friends_to_db
		user_exists = false
		to_add = params[:name].to_s
		@return = false

		if !validate(to_add, "handle")
			render plain: @return.inspect
			return
		end

		to_add = validate(to_add, "handle")

		for lines in UserSetting.where(username: current_user.username)
			user_exists = true
			all_friends = lines.friends
			if !(all_friends.include? to_add)
				lines.friends << to_add
				lines.save
			end
		end
		if !user_exists
			new_entry = UserSetting.create(:settings => [to_add.to_s], :username => current_user.username, :friends => [], :contests => [], :handle => "")
		end
		@return = to_add
		render plain: @return
	end

	# Removes friend passed by parameter from database
	def remove_friends_from_db
		to_delete = params[:name].to_s
		to_delete = validate(to_delete, "handle")
		@return = "false"
		for lines in UserSetting.where(username: current_user.username)
			all_friends = lines.friends
			if all_friends.include? to_delete
				lines.friends.delete(to_delete)
				lines.save
				@return = to_delete
			end
		end
		render plain: @return
	end

	# Adds contest passed by parameter to database
	def add_contest_to_db
		user_exists = false
		to_add = params[:name].to_s
		@return = false

		if !validate(to_add, "contest")
			render plain: @return.inspect
			return
		end

		for lines in UserSetting.where(username: current_user.username)
			user_exists = true
			all_contests = lines.contests
			if !(all_contests.include? to_add)
				lines.contests << to_add
				lines.save
				@return = true
			end
		end
		if !user_exists
			new_entry = UserSetting.create(:settings => [], :username => current_user.username, :friends => [], :contests => [to_add], :handle => "")
			@return = true
		end
		render plain: @return.inspect
	end

	# Removes contest passed by parameter from database
	def remove_contest_from_db
		to_delete = params[:name].to_s
		@return = false
		for lines in UserSetting.where(username: current_user.username)
			all_contests = lines.contests
			if all_contests.include? to_delete
				lines.contests.delete(to_delete)
				lines.save
				@return = true
			end
		end
		render plain: @return.inspect
	end

end
