class PagesController < ApplicationController
	def about
		@title = 'About us'
		@content = 'Projeto de Técnicas de Programação II'
	end
end
