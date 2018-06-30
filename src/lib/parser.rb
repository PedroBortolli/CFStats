module Parser
	
	include Utility
	include Api

	# Calls CF API and stores basic user information
	def build_user_info (handle, id, info)
		result = get_user_info(handle)
		handle_info = result['result'][0]
		info['handle'+id.to_s] = handle_info
		if info['handle'+id.to_s]['rating'] >= 3000
			info['handle'+id.to_s]['first_letter'+id.to_s] =  'legendary-user-first-letter'
		else
			info['handle'+id.to_s]['first_letter'+id.to_s] =  color(info['handle'+id.to_s]['rating'])   
		end
	end

	# Calls CF API and stores all contests from a user
	def build_contests (handle, id, info)
		contests = get_user_contests(handle)
		worst_rating = 999999
		amount_contests = 0
		max_up = -999999
		max_down = 999999
		contests.each do |contest|
			worst_rating = min(contest['oldRating'], worst_rating)
			worst_rating = min(contest['newRating'], worst_rating)
			max_up = max(contest['newRating']-contest['oldRating'], max_up)
			max_down = min(contest['newRating']-contest['oldRating'], max_down)
			amount_contests += 1
			contest['url'] = "http://codeforces.com/contest/" + contest['contestId'].to_s
		end
		info['handle'+id.to_s]['contests'] = contests
		if worst_rating == 999999
			info['handle'+id.to_s]['worstRating'] = "- "
		else
			info['handle'+id.to_s]['worstRating'] = worst_rating
		end
		if max_up == -999999
			info['handle'+id.to_s]['maxUp'] = "-"
		else
			info['handle'+id.to_s]['maxUp'] = max_up
		end
		if max_down == 999999
			info['handle'+id.to_s]['maxDown'] = "-"
		else
			info['handle'+id.to_s]['maxDown'] = max_down
		end
		if amount_contests == 0
			info['handle'+id.to_s]['rating'] = "Unrated"
			info['handle'+id.to_s]['maxRating'] = "- "
		end
	end

	# Calls CF API and stores all problems that a user solved
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
		info['handle'+id.to_s]['unsolvedProblems'].sort_by!{|a| a["contestId"].to_i || 0}
	end

	# Builds all information in common between the two users being compared
	def build_common (info)
		info['commonProblems'] = info['handle1']['acProblems'] & info['handle2']['acProblems']
		info['commonProblems'].sort_by!{|a| a["contestId"].to_i || 0}
		info['handle1']['uniqueProblems'] = info['handle1']['acProblems'] - info['handle2']['acProblems']
		info['handle2']['uniqueProblems'] = info['handle2']['acProblems'] - info['handle1']['acProblems']
		info['handle1']['uniqueProblems'].sort_by!{|a| a["contestId"].to_i || 0}
		info['handle2']['uniqueProblems'].sort_by!{|a| a["contestId"].to_i || 0}
		if info['handle1']['rating'] == "Unrated" or info['handle2']['rating'] == "Unrated"
			info['ratingDifference'] = "?"
		else
			info['ratingDifference'] = info['handle1']['rating'] - info['handle2']['rating']
		end

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
		info['handle1']['winsOver'] = user1_wins
		info['handle2']['winsOver'] = user2_wins
		info['commonContests'] = commonContests
		aux = info['handle1']['contests'] + info['handle2']['contests']
		info['contests'] = aux.sort{|a,b| a['ratingUpdateTimeSeconds'] <=> b['ratingUpdateTimeSeconds']}
	end

	# Builds solved problems and attempted contests from a user
	def build_solved_problems_and_attempted_contests (handle)
		profile_info = build_result(handle, nil)
		ac_problems = profile_info['handle1']['acProblems']
		unsolved_problems = profile_info['handle1']['unsolvedProblems']
		problems_solved = Hash.new
		contests_attempted = Hash.new

		for ac_problem in ac_problems
			problems_solved.store(ac_problem['contestId'].to_s + ac_problem['index'], true)
			contests_attempted.store(ac_problem['contestId'].to_s, true)
		end

		for unsolved_problem in unsolved_problems
			contests_attempted.store(unsolved_problem['contestId'].to_s, true)
		end

		return problems_solved, contests_attempted		
	end

	# Merges all contests from both user to create a timeline of both users' ratings over time
	def merge_contests (info)
		seen = Hash.new
		contests_merged = Array.new
		prev1 = nil
		prev2 = nil
		for contest in info['contests']
			id = contest['contestId']
			tme = contest['ratingUpdateTimeSeconds']
			ok = false
			if !(seen.key?(id))
				handle1 = contest['handle']
				rating1 = contest['newRating']
				for contest2 in info['contests']
					id2 = contest2['contestId']
					if id == id2
						handle2 = contest2['handle']
						if handle1 != handle2
							rating2 = contest2['newRating']
							if handle1 == info['handle1']['handle']
								contests_merged.push([tme, rating1, rating2])
								prev1 = rating1
								prev2 = rating2
							else
								contests_merged.push([tme, rating2, rating1])
								prev1 = rating2
								prev2 = rating1
							end
							ok = true
						end
					end
				end
				if !ok
					if handle1 == info['handle1']['handle']
						contests_merged.push([tme, rating1, prev2])
						prev1 = rating1
					else
						contests_merged.push([tme, prev1, rating1])
						prev2 = rating1
					end
				end
				seen.store(id, true)
			end
		end
		info['contestsMerged'] = contests_merged
	end

	# Calls all the functions above and stores them to the hash "Info" to be returned
	def build_result (handle1, handle2)
		info = Hash.new
		build_user_info(handle1, 1, info)
		build_problems(handle1, 1, info)
		build_contests(handle1, 1, info)
		if (handle2 != nil)
			build_user_info(handle2, 2, info)
			build_problems(handle2, 2, info)
			build_contests(handle2, 2, info)
			build_common(info)
			merge_contests(info)
		end
		return info
	end
end