class PagesController < ApplicationController
	include PagesHelper
	skip_before_action :verify_authenticity_token
	before_action :authenticate_user!, :except => [:index, :search, :about, :result, :test]

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
		if handle1.empty? or handle2.to_s.empty?
			render html: "Please provide 2 valid Codeforces handles!"
			return
		end
		@info = build_result(handle1, handle2)
		if @info['handle1']['rating'] >= 3000
			@first_letter1 =  'legendary-user-first-letter'
		else
			@first_letter1 =  color(@info['handle1']['rating'])   
		end

		if @info['handle2']['rating'] >= 3000
			@first_letter2 =  'legendary-user-first-letter'
		else
			@first_letter2 =  color(@info['handle2']['rating'])   
		end
	end

	def test
		#### metodo para testar novas features, sera apagado futuramente! ####
		#username = current_user.username

		for user in UserSetting.all
			user.delete
		end
		#return

	end

end
