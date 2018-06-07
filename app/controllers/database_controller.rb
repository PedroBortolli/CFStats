class DatabaseController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :authenticate_user!, :except => [:index, :search, :about, :result, :test]

	def add_links_to_db
		to_add = params[:name].to_s
		user_exists = false
		for lines in UserSetting.where(username: current_user.username)
			user_exists = true
			all_links = lines.settings
			if !(all_links.include? to_add)
				lines.settings << to_add
			end
			lines.save
		end
		if !user_exists
			new_entry = UserSetting.create(:settings => [to_add.to_s], :username => current_user.username, :friends => [])
			new_entry.save
		end
	end

	def remove_links_from_db
		to_delete = params[:name].to_s
		for lines in UserSetting.where(username: current_user.username)
			all_links = lines.settings
			if all_links.include? to_delete
				lines.settings.delete(to_delete)
			end
			lines.save
		end
	end

	def add_friends_to_db
		user_exists = false
		to_add = params[:name].to_s
		for lines in UserSetting.where(username: current_user.username)
			user_exists = true
			all_friends = lines.friends
			if !(all_friends.include? to_add)
				lines.friends << to_add
			end
			lines.save
		end
		if !user_exists
			new_entry = UserSetting.create(:settings => [to_add.to_s], :username => current_user.username, :friends => [])
		end
	end

	def remove_friends_from_db
		to_delete = params[:name].to_s
		for lines in UserSetting.where(username: current_user.username)
			all_friends = lines.friends
			if all_friends.include? to_delete
				lines.friends.delete(to_delete)
			end
			lines.save
		end
	end
end
