module Api
	def call_api (url)
		begin
			t1 = Time.now
			response_from_api = RestClient.get(url)
			t2 = Time.now
			puts("pra dar o get  demorou  => " + (t2-t1).to_s)
			parsed_json = JSON.parse(response_from_api)
			t3 = Time.now
			puts("pra parsear  demorou  => " + (t3-t2).to_s)
			return parsed_json
		rescue => exception
			puts("aaaaaaaaaaaa", exception.http_code)
		end
	end

	def get_user_info (handle)
		base = 'http://codeforces.com/api/user.info?handles='
		url = base + handle.to_s
		return call_api(url)
	end

	def get_user_problems (handle)
		base = 'http://codeforces.com/api/user.status?handle='
		url = base + handle.to_s
		api = call_api(url)
		return api['result']
	end

	def get_user_contests (handle)
		base = 'http://codeforces.com/api/user.rating?handle='
		url = base + handle.to_s
		api = call_api(url)
		return api['result']
	end

	def validate (id, type)
		if (type == "handle")
			begin
				base = "http://codeforces.com/api/user.info?handles="
				url = base + id.to_s
				response_from_api = RestClient.get(url)
				return true
			rescue => exception
				puts("Deu ruim a chamada de API  =>  ", exception.http_code)
				return false
			end

		elsif (type == "contest")
			begin
				base = "http://codeforces.com/api/contest.status?contestId="
				url = base + id.to_s + "&count=1"
				response_from_api = RestClient.get(url)
				return true
			rescue => exception
				puts("Deu ruim a chamada de API  =>  ", exception.http_code)
				return false
			end

		elsif (type == "problem")
			base = "http://codeforces.com/api/problemset.problems"
			url = base
			all_problems = call_api(url)["result"]["problems"]
			
			id_size = id.length
			problem_index = id[id_size-1]
			contest_number = id[0...-1]
			puts(problem_index, contest_number)
			for problem in all_problems
				if problem["contestId"].to_s == contest_number
					if problem["index"].to_s == problem_index
						return true
					end
				end 
			end
			return false
		end
	end
end