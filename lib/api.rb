module Api
	def call_api (url)
		t1 = Time.now
		response_from_api = RestClient.get(url)
		t2 = Time.now
		puts("pra dar o get  demorou  => " + (t2-t1).to_s)
		parsed_json = JSON.parse(response_from_api)
		t3 = Time.now
		puts("pra parsear  demorou  => " + (t3-t2).to_s)
		return parsed_json
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
end