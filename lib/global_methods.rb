require 'rest-client'
require 'json'

module GlobalMethods
	def  pull_from_api (handle)
		base = 'http://codeforces.com/api/user.info?handles='
		url = base + handle
		response = RestClient.get(url)
		parsed = JSON.parse(response)
		return parsed['result'][0]
	end
end