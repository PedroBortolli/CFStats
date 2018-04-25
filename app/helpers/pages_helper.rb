module PagesHelper
	def call_api (url)
		response = RestClient.get(url)
		parsed = JSON.parse(response)
		return parsed
	end

	def max (a, b)
		a > b ? a : b
	end

	def min (a, b)
		a > b ? b : a
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

	def user_info (handle)
		ret = get_user_info(handle)
		return ret['result'][0]
	end

	def contests_info (handle)
		base = 'http://codeforces.com/api/user.rating?handle='
		url = base + handle.to_s
		api = call_api(url)
		worst_rating = 1500
		amount_contests = 0
		api['result'].each do |contest|
			worst_rating = min(contest['oldRating'], worst_rating)
			worst_rating = min(contest['newRating'], worst_rating)
			amount_contests += 1
		end

		info = Hash.new
		info['worstRating'] = worst_rating
		info['amountContests'] = amount_contests
		return info
	end

	def build_info (handle1, handle2)
		info = Hash.new
		info['handle1'] = user_info(handle1)
		info['handle2'] = user_info(handle2)
		info['ratingDifference'] = info['handle1']['rating'] - info['handle2']['rating']
		info['maxRatingDifference'] = info['handle1']['maxRating'] - info['handle2']['maxRating']
		problems = Array.new(3)
		problems[1] = get_user_problems(handle1)
		problems[2] = get_user_problems(handle2)
		ok = Array.new(3) {Array.new}
		seen = Array.new(3) {Hash.new}
		unsolved = Array.new(3) {Array.new}
		tags = Hash.new
		for i in 1..2
			tags.clear
			problems[i].each do |submission|
				if !seen[i].key?(submission['problem'])
					seen[i].store(submission['problem'], 1)
					cpy = submission['problem'].clone
					if cpy['contestId'].to_i < 99999
						base = "http://www.codeforces.com/problemset/problem/"
						cpy['url'] = base + cpy['contestId'].to_s + "/" + cpy['index'].to_s
					else
						base = "http://www.codeforces.com/gym/"
						cpy['url'] = base + cpy['contestId'].to_s + "/problem/" + cpy['index'].to_s
					end
					if submission['verdict'] == 'OK'
						ok[i].push(cpy)
						cpy['tags'].each do |tag|
							if !tags.key?(tag.to_s)
								tags[tag] = 1
							else
								tags[tag] += 1
							end
						end
					else
						unsolved[i].push(cpy)
					end
				end
			end
			info['handle'+i.to_s]['unsolvedProblems'] = unsolved[i]
			info['handle'+i.to_s]['tags'] = tags.clone
		end
		
		info['commonProblems'] = ok[1] & ok[2]
		info['commonProblems'].sort_by!{|a| a["contestId"]}

		info['handle1']['acCount'] = ok[1].size
		info['handle2']['acCount'] = ok[2].size

		info['handle1']['tags'] = info['handle1']['tags'].sort_by{|_key, value| -value}.to_h
		info['handle2']['tags'] = info['handle2']['tags'].sort_by{|_key, value| -value}.to_h

		info['handle1']['unsolvedProblems'].sort_by!{|a| a["contestId"]}
		info['handle2']['unsolvedProblems'].sort_by!{|a| a["contestId"]}

		contests = contests_info(handle1)
		info['handle1']['worstRating'] = contests['worstRating']
		info['handle1']['amountContests'] = contests['amountContests']

		contests = contests_info(handle2)
		info['handle2']['worstRating'] = contests['worstRating']
		info['handle2']['amountContests'] = contests['amountContests']

		return info
	end

end
