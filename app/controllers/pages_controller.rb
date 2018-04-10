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
		@info = build_info(handle1, handle2)
	end

	def test
		#### metodo para testar novas features, sera apagado futuramente! ####
	end

end
