module Updater

	include Parser

	# Makes an API request to Codeforces to update a handle information
	def update_user_info (handle)
		puts("Updating info for user  =>  " + handle.to_s)
		start = Time.now
		@info_handle = build_result(handle)
		db_entry = UserInformation.where(handle: handle.downcase)[0]
		db_entry.info = @info_handle
		db_entry.updates = db_entry.updates + 1
		db_entry.save
		finish = Time.now
		puts("		handle  " + handle.to_s + "  updated in  " + (finish-start).to_s + " seconds")
	end

	# Checks whether information for user exists or not and sets it up
	# Returns info of the comparison, info for handle 1 and infor for handle 2
	def set_up_result (handle1, handle2, force_update)
		db_entry_1 = UserInformation.where(handle: handle1.downcase)[0]
		db_entry_2 = UserInformation.where(handle: handle2.downcase)[0]
		if db_entry_1 == nil
			@info_handle_1 = build_result(handle1)
			UserInformation.create(:handle => handle1.downcase, :info => @info_handle_1, :updates => 1)
		else
			if force_update == true
				update_user_info(handle1.downcase)
			end
			@info_handle_1 = db_entry_1.info
		end
		if db_entry_2 == nil
			@info_handle_2 = build_result(handle2)
			UserInformation.create(:handle => handle2.downcase, :info => @info_handle_2, :updates => 1)
		else
			if force_update == true
				update_user_info(handle2.downcase)
			end
			@info_handle_2 = db_entry_2.info
		end
		@info_handle_1['updatedAt'] = UserInformation.where(handle: handle1.downcase)[0].updated_at
		@info_handle_2['updatedAt'] = UserInformation.where(handle: handle2.downcase)[0].updated_at
		@info = build_comparison(@info_handle_1, @info_handle_2)
		return @info, @info_handle_1, @info_handle_2
	end

	def update_multiple
		db = UserInformation.all
		cont = 0
		max_handles = 25
		oldest_entry = UserInformation.all[0].updated_at.to_i
		current_time = Time.now.to_i
		time_elapsed_since_update = current_time-oldest_entry
		#update_time = 24*60*60 - 100
		update_time = 10*60 - 30
		puts("Time elapsed since last DB update  =>  " + time_elapsed_since_update.to_s + "  seconds")
		# Only allows an entire DB update every 24 hours (100 seconds margin)
		if time_elapsed_since_update < update_time
			puts("		that's too soon to try to update the entire DB again")
			return "Too soon to update the entire DB again..."
		end
		for db_entry in db
			update_user_info(db_entry.handle)
			# Aborts update if max_handles has been exceeded
			cont += 1
			if cont == max_handles
				break
			end
		end
		return "DB succesfully updated!"
	end

end