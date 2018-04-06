class PagesController < ApplicationController
	include PagesHelper
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

		info1 = get_user_info(input1.to_s)
		info2 = get_user_info(input2.to_s)

		@handle1 = info1['handle']
		@rating1 = info1['rating']
		@maxRating1 = info1['maxRating']

		@handle2 = info2['handle']
		@rating2 = info2['rating']
		@maxRating2 = info2['maxRating']

		@ratingDifference = @rating1-@rating2
		@maxRatingDifference = @maxRating1-@maxRating2

		@problems1 = get_user_problems(@handle1)
		ok1 = Array.new
		ok2 = Array.new
		@problems1.each do |i|
			if i['verdict'] == 'OK'
				ok1.push(i['problem'])
			end
		end

		@problems2 = get_user_problems(@handle2)
		@problems2.each do |i|
			if i['verdict'] == 'OK'
				ok2.push(i['problem'])
			end
		end

		@problems = ok1 & ok2
	end


	def test
		#### metodo para testar novas features, sera apagado futuramente! ####
	end

end
