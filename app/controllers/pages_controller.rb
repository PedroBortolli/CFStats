class PagesController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :authenticate_user!, :except => [:index, :search, :about, :result, :test]

	include Parser
	include Api

	def index
	end

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

	def retrieve_solved
		render json: @@problems_solved_shared
	end

	def retrieve_attempted
		render json: @@contests_attempted_shared
	end

	def retrieve_handle
		render html: @@handle_shared
	end

	def about
		@title = 'About us'
		@content = 'Projeto de Técnicas de Programação II'
	end

	def search
	end

	def add
	end

	def result
		handle1 = params[:param1].to_s
		handle2 = params[:param2].to_s
		if !validate(handle1, "handle") or !validate(handle2, "handle")
			render html: "Please provide 2 valid Codeforces handles!"
			return
		end
		@info = build_result(handle1, handle2)
	end

	def test
		puts("Eae:")
		puts(UserSetting.where(username: current_user.username).length)
		puts("")
	end

end
