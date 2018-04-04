require 'global_methods'

class PagesController < ApplicationController
	include GlobalMethods

	def index

	end

	def about
		@title = 'About us'
		@content = 'Projeto de Técnicas de Programação II'
	end

	def result
		input1 = params[:param1]
		input2 = params[:param2]

		if input1.to_s.empty? or input2.to_s.empty?
			render html: "Please provide 2 valid Codeforces handles!"
			return
		end

		info1 = pull_from_api(input1.to_s)
		info2 = pull_from_api(input2.to_s)

		@handle1 = info1['handle']
		@rating1 = info1['rating']
		@maxRating1 = info1['maxRating']

		@handle2 = info2['handle']
		@rating2 = info2['rating']
		@maxRating2 = info2['maxRating']

		@ratingDifference = @rating1-@rating2
		@maxRatingDifference = @maxRating1-@maxRating2
	end

end
