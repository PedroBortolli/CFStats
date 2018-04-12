module PagesHelper
	def get_user_info (handle)
		base = 'http://codeforces.com/api/user.info?handles='
		url = base + handle.to_s
		response = RestClient.get(url)
		parsed = JSON.parse(response)
		return parsed
	end

	def get_user_problems (handle)
		base = 'http://codeforces.com/api/user.status?handle='
		url = base + handle.to_s
		response = RestClient.get(url)
		parsed = JSON.parse(response)
		return parsed['result']
	end

	def user_info (handle)
		ret = get_user_info(handle)
		return ret['result'][0]
	end

	def build_info (handle1, handle2)
		ret = Hash.new
		ret['handle1'] = user_info(handle1)
		ret['handle2'] = user_info(handle2)
		ret['ratingDifference'] = ret['handle1']['rating'] - ret['handle2']['rating']
		ret['maxRatingDifference'] = ret['handle1']['maxRating'] - ret['handle2']['maxRating']

		problems = Array.new(3)
		problems[1] = get_user_problems(handle1)
		problems[2] = get_user_problems(handle2)
		ok = Array.new(3) {Array.new}
		seen = Array.new(3) {Hash.new}
		tags = Hash.new
		for i in 1..2
			tags.clear
			problems[i].each do |submission|
				if submission['verdict'] == 'OK' and !seen[i].key?(submission)
					ok[i].push(submission['problem'])
					seen[i].store(submission, 1)
					submission['problem']['tags'].each do |tag|
						if !tags.key?(tag.to_s)
							tags[tag] = 1
						else
							tags[tag] += 1
						end
					end
				end
			end
			ret['handle'+i.to_s]['tags'] = tags.clone
		end
		
		ret['commonProblems'] = ok[1] & ok[2]
		#ret = ret.sort_by {|a| a[:contestId]}
		return ret
	end

end
