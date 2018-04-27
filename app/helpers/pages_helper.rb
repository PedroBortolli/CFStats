module PagesHelper
	def call_api (url)
		response_from_api = RestClient.get(url)
		parsed_json = JSON.parse(response_from_api)
		return parsed_json
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

	def build_user_info (handle, id, info)
		result = get_user_info(handle)
		handle_info = result['result'][0]
		info['handle'+id.to_s] = handle_info
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

	def build_problems (handle, id, info)
		problems = get_user_problems(handle)
		acProblems = Array.new
		seenProblem = Hash.new
		unsolvedProblems = Array.new
		problemTags = Hash.new
		problems.each do |submission|
			if !seenProblem.key?(submission['problem'])
				seenProblem.store(submission['problem'], 1)
				submissionCopy = submission['problem'].clone
				if submissionCopy['contestId'].to_i < 99999
					base = "http://www.codeforces.com/problemset/problem/"
					submissionCopy['url'] = base + submissionCopy['contestId'].to_s + "/" + submissionCopy['index'].to_s
				else
					base = "http://www.codeforces.com/gym/"
					submissionCopy['url'] = base + submissionCopy['contestId'].to_s + "/problem/" + submissionCopy['index'].to_s
				end
				if submission['verdict'] == 'OK'
					acProblems.push(submissionCopy)
					submissionCopy['tags'].each do |tag|
						if !problemTags.key?(tag.to_s)
							problemTags[tag] = 1
						else
							problemTags[tag] += 1
						end
					end
				else
					unsolvedProblems.push(submissionCopy)
				end
			end
		end
		info['handle'+id.to_s]['unsolvedProblems'] = unsolvedProblems
		info['handle'+id.to_s]['problemTags'] = problemTags
		info['handle'+id.to_s]['acProblems'] = acProblems
		info['handle'+id.to_s]['problemTags'] = info['handle'+id.to_s]['problemTags'].sort_by{|_key, value| -value}.to_h
		info['handle'+id.to_s]['unsolvedProblems'].sort_by!{|a| a["contestId"]}
	end

	def build_common (info)
		info['commonProblems'] = info['handle1']['acProblems'] & info['handle2']['acProblems']
		info['commonProblems'].sort_by!{|a| a["contestId"]}
		info['handle1']['uniqueProblems'] = info['handle1']['acProblems'] - info['handle2']['acProblems']
		info['handle2']['uniqueProblems'] = info['handle2']['acProblems'] - info['handle1']['acProblems']
		info['handle1']['uniqueProblems'].sort_by!{|a| a["contestId"]}
		info['handle2']['uniqueProblems'].sort_by!{|a| a["contestId"]}
		info['ratingDifference'] = info['handle1']['rating'] - info['handle2']['rating']
		info['maxRatingDifference'] = info['handle1']['maxRating'] - info['handle2']['maxRating']
	end

	def build_result (handle1, handle2)
		info = Hash.new

		build_user_info(handle1, 1, info)
		build_user_info(handle2, 2, info)
		
		build_problems(handle1, 1, info)
		build_problems(handle2, 2, info)
		build_common(info)

		contests = contests_info(handle1)
		info['handle1']['worstRating'] = contests['worstRating']
		info['handle1']['amountContests'] = contests['amountContests']

		contests = contests_info(handle2)
		info['handle2']['worstRating'] = contests['worstRating']
		info['handle2']['amountContests'] = contests['amountContests']

		return info
	end

	def color (rating)
		if rating < 1200
			return 'rated-user user-gray'
		elsif rating < 1400
			return 'rated-user user-green'
		elsif rating < 1600
			return 'rated-user user-cyan'
		elsif rating < 1900
			return 'rated-user user-blue'
		elsif rating < 2200
			return 'rated-user user-violet'
		elsif rating < 2400
			return 'rated-user user-orange'
		else
			return 'rated-user user-red'
		end
	end


end
