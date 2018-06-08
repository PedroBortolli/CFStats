class PagesController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :authenticate_user!, :except => [:index, :search, :about, :result, :test]

	include Parser
	include DatabaseHelper

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
		puts(validate(handle1, "user"))
		puts(validate(handle2, "user"))
		if handle1.empty? or handle2.to_s.empty?
			render html: "Please provide 2 valid Codeforces handles!"
			return
		end
		@info = build_result(handle1, handle2)
	end

	def test
		validate("www.codeforces.com", "user")
	end

end
