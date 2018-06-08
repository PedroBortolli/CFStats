class DatabaseController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :authenticate_user!, :except => [:index, :search, :about, :result, :test]

	include DatabaseHelper
	include ApiModule

	def update_handle_to_db
		api_teste
		to_add = params[:name].to_s
		user_exists = false
		@return = false
		for lines in UserSetting.where(username: current_user.username)
			user_exists = true
			lines.handle = to_add
			lines.save
			@return = true
		end
		if !user_exists
			new_entry = UserSetting.create(:settings => [], :username => current_user.username, :friends => [], :contests => [], :handle => to_add)
			new_entry.save
			@return = true
		end
		render plain: @return.inspect
		#colocar @return.to_json pra retornar isso como json se quiser
	end


	def add_links_to_db
		to_add = params[:name].to_s
		user_exists = false
		@return = false
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

	def add_friends_to_db
		user_exists = false
		to_add = params[:name].to_s
		@return = false
		for lines in UserSetting.where(username: current_user.username)
			user_exists = true
			all_friends = lines.friends
			if !(all_friends.include? to_add)
				lines.friends << to_add
				lines.save
				@return = true
			end
		end
		if !user_exists
			new_entry = UserSetting.create(:settings => [to_add.to_s], :username => current_user.username, :friends => [], :contests => [], :handle => "")
			@return = true
		end
		render plain: @return.inspect
	end

	def remove_friends_from_db
		to_delete = params[:name].to_s
		@return = false
		for lines in UserSetting.where(username: current_user.username)
			all_friends = lines.friends
			if all_friends.include? to_delete
				lines.friends.delete(to_delete)
				lines.save
				@return = true
			end
		end
		render plain: @return.inspect
	end

	def add_contest_to_db
		user_exists = false
		to_add = params[:name].to_s
		@return = false
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
