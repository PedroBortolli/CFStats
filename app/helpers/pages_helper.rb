module PagesHelper
	def get_user_info (handle)
		base = 'http://codeforces.com/api/user.info?handles='
		url = base + handle
		response = RestClient.get(url)
		parsed = JSON.parse(response)
		return parsed['result'][0]
	end

	def get_user_problems (handle)
		base = 'http://codeforces.com/api/user.status?handle='
		url = base + handle
		response = RestClient.get(url)
		parsed = JSON.parse(response)
		return parsed['result']
	end
end
