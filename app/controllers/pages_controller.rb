class PagesController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :authenticate_user!, :except => [:index, :search, :about, :result, :test]

	include Parser
	include Api

	def index
	end

	def profile
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
	end

end
