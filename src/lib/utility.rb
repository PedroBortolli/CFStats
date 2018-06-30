module Utility

	# Returns max element between a and b
	def max (a, b)
		a > b ? a : b
	end

	# Returns min element between a and b
	def min (a, b)
		a > b ? b : a
	end

	# Returns color according to rating number
	def color (rating)
		if rating.instance_of? String
			return 'black'
		elsif rating < 1200
			return 'rated-user user-gray'
		elsif rating < 1400
			return 'rated-user user-green'
		elsif rating < 1600
			return 'rated-user user-cyan'
		elsif rating < 1900
			return 'rated-user user-blue'
		elsif rating < 2100
			return 'rated-user user-violet'
		elsif rating < 2400
			return 'rated-user user-orange'
		else
			return 'rated-user user-red'
		end
	end
end