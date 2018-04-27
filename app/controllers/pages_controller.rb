class PagesController < ApplicationController
	include PagesHelper
	def index

	end

	def about
		@title = 'About us'
		@content = 'Projeto de Técnicas de Programação II'
	end

	def result
		handle1 = params[:param1].to_s
		handle2 = params[:param2].to_s
		if handle1.empty? or handle2.to_s.empty?
			render html: "Please provide 2 valid Codeforces handles!"
			return
		end
		@info = build_result(handle1, handle2)
		if @info['handle1']['rating'] >= 2900
			@first_letter1 =  'legendary-user-first-letter'
		else
			@first_letter1 =  color(@info['handle1']['rating'])   
		end

		if @info['handle2']['rating'] >= 2900
			@first_letter2 =  'legendary-user-first-letter'
		else
			@first_letter2 =  color(@info['handle2']['rating'])   
		end
	end

	def test
		#### metodo para testar novas features, sera apagado futuramente! ####
	end

end
