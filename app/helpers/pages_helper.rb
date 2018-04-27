module PagesHelper
	def max (a, b)
		a > b ? a : b
	end

	def min (a, b)
		a > b ? b : a
	end

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

	def build_user_info (handle, id, info)
		result = get_user_info(handle)
		handle_info = result['result'][0]
		info['handle'+id.to_s] = handle_info
	end

	def build_contests (handle, id, info)
		contests = get_user_contests(handle)
		worst_rating = 1500
		amount_contests = 0
		max_up = 0
		max_down = 0
		contests.each do |contest|
			worst_rating = min(contest['oldRating'], worst_rating)
			worst_rating = min(contest['newRating'], worst_rating)
			max_up = max(contest['newRating']-contest['oldRating'], max_up)
			max_down = min(contest['newRating']-contest['oldRating'], max_down)
			amount_contests += 1
			contest['url'] = "http://codeforces.com/contest/" + contest['contestId'].to_s
		end
		info['handle'+id.to_s]['contests'] = contests
		info['handle'+id.to_s]['worstRating'] = worst_rating
		info['handle'+id.to_s]['maxUp'] = max_up
		info['handle'+id.to_s]['maxDown'] = max_down
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

		commonContests = Array.new
		seenContests = Hash.new
		aux = Hash.new
		aux2 = Hash.new{Hash.new}
		user1_wins = 0
		user2_wins = 0
		info['handle1']['contests'].each do |contest_user1|
			info['handle2']['contests'].each do |contest_user2|
				if contest_user1['contestId'] == contest_user2['contestId']
					if !seenContests.key?(contest_user1['contestId'])
						seenContests.store(contest_user1['contestId'], 1)
						aux2.clear
						aux.clear
						aux.store('rank', contest_user1['rank'])
						aux2.store('handle1', aux.clone)
						aux.clear
						aux.store('rank', contest_user2['rank'])
						aux2.store('handle2', aux.clone)
						aux2.store('contestName', contest_user1['contestName'])
						aux2.store('url', contest_user1['url'])
						if contest_user1['rank'] < contest_user2['rank']
							user1_wins += 1
						elsif contest_user2['rank'] < contest_user1['rank']
							user2_wins += 1
						end
						commonContests.push(aux2.clone)
					end 
				end
			end
		end
		puts(user1_wins)
		puts(user2_wins)
		info['handle1']['winsOver'] = user1_wins
		info['handle2']['winsOver'] = user2_wins
		info['commonContests'] = commonContests
	end

	def build_result (handle1, handle2)
		info = Hash.new
		build_user_info(handle1, 1, info)
		build_user_info(handle2, 2, info)
		build_problems(handle1, 1, info)
		build_problems(handle2, 2, info)
		build_contests(handle1, 1, info)
		build_contests(handle2, 2, info)
		build_common(info)
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
