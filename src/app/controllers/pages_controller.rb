class PagesController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :authenticate_user!, :except => [:index, :search, :about, :result, :test]

	include Parser
	include Api
	include ActionView::Helpers::AssetUrlHelper

	def index
	end

	# Builds all information about user logged into the website
	def profile
		if user_signed_in?
			db_entry = UserSetting.where(username: current_user.username)[0]
			if db_entry != nil
				handle = db_entry.handle
				@problems_solved, @contests_attempted = build_solved_problems_and_attempted_contests(handle)
				@@handle_shared = handle
				@@problems_solved_shared = @problems_solved
				@@contests_attempted_shared = @contests_attempted
			end
		end
	end

	# Returns current user's solved problems to ajax calls
	def retrieve_solved
		render json: @@problems_solved_shared
	end

	# Returns current user's attempted contests to ajax calls
	def retrieve_attempted
		render json: @@contests_attempted_shared
	end

	# Returns current user's handle to ajax calls
	def retrieve_handle
		render html: @@handle_shared
	end

	# Passes path to compare.png to javascript functions
	def retrieve_compare_icon_path
		path = ActionController::Base.helpers.asset_path("compare.png")
		render html: path
	end

	# Passes path to cancel.png to javascript functions
	def retrieve_cancel_icon_path
		path = ActionController::Base.helpers.asset_path("cancel.png")
		render html: path
	end

	def about
	end

	def search
	end

	def add
	end

	# Passes both handles removing leading and trailing whitespaces as parameters to the /result page
	# alongside with their information to be displayed in their comparison
	def result
		handle1 = params[:param1].to_s.strip
		handle2 = params[:param2].to_s.strip
		if !validate(handle1, "handle") or !validate(handle2, "handle")
			render html: "Please provide 2 valid Codeforces handles!"
			return
		end
		@info = build_result(handle1, handle2)
	end

end
