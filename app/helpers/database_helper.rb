module DatabaseHelper

	#user.info
	#contest.status


	def validate (id, type)
		if (type == "user")
			begin
				base = "http://codeforces.com/api/user.info?handles="
				url = base + id
				response_from_api = RestClient.get(url)
				return true
			rescue => exception
				puts("Deu ruim a chamada de API  =>  ", exception.http_code)
				return false
			end
		end
	end
end