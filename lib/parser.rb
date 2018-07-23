module Parser
	
	include Utility
	include Api
	require 'set'

	# Calls CF API and stores basic user information
	def build_user_info (handle, info)
		result = get_user_info(handle)
		handle_info = result['result'][0]
		info['user'] = handle_info
		if info['user'].key?('rating') and info['user']['rating'] >= 3000
			info['user']['first_letter'] =  'legendary-user-first-letter'
		else
			if !info['user'].key?('rating')
				info['user']['rating'] = "Unrated"
			end
			info['user']['first_letter'] =  color(info['user']['rating'])   
		end
	end

	# Calls CF API and stores all contests from a user
	def build_contests (handle, info)
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
		info['contests'] = contests
		if worst_rating == 999999
			info['worstRating'] = "- "
		else
			info['worstRating'] = worst_rating
		end
		if max_up == -999999
			info['maxUp'] = "-"
		else
			info['maxUp'] = max_up
		end
		if max_down == 999999
			info['maxDown'] = "-"
		else
			info['maxDown'] = max_down
		end
		if amount_contests == 0
			info['maxRating'] = "- "
		end
	end

	# Calls CF API and stores all problems that a user solved
	def build_problems (handle, info)
		problems = get_user_problems(handle)
		acProblems = Array.new
		seenProblem = Hash.new
		unsolvedProblems = Array.new
		problemTags = Hash.new
		problems.each do |submission|
			if !seenProblem.key?(submission['problem'])
				seenProblem.store(submission['problem'], 1)
				submissionCopy = submission['problem'].clone
				unsolvedProblems.push(submission['problem'])
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
				end
			end
		end
		problems.each do |submission|
			if submission['verdict'] == 'OK'
				unsolvedProblems.delete(submission['problem'])
			end
		end
		info['unsolvedProblems'] = unsolvedProblems
		info['problemTags'] = problemTags
		info['acProblems'] = acProblems
		info['problemTags'] = info['problemTags'].sort_by{|_key, value| -value}.to_h
		info['unsolvedProblems'].sort_by!{|a| a["contestId"].to_i || 0}
	end

	# Builds all information in common between the two users being compared
	def build_common (info1, info2, info)
		info['commonProblems'] = info1['acProblems'] & info2['acProblems']
		info['commonProblems'].sort_by!{|a| a["contestId"].to_i || 0}
		info1['uniqueProblems'] = info1['acProblems'] - info2['acProblems']
		info2['uniqueProblems'] = info2['acProblems'] - info1['acProblems']
		info1['uniqueProblems'].sort_by!{|a| a["contestId"].to_i || 0}
		info2['uniqueProblems'].sort_by!{|a| a["contestId"].to_i || 0}
		if info1['user']['rating'] == "Unrated" or info2['user']['rating'] == "Unrated"
			info['ratingDifference'] = "?"
		else
			info['ratingDifference'] = info1['user']['rating'] - info2['user']['rating']
		end

		commonContests = Array.new
		seenContests = Hash.new
		aux = Hash.new
		aux2 = Hash.new{Hash.new}
		user1_wins = 0
		user2_wins = 0
		info1['contests'].each do |contest_user1|
			info2['contests'].each do |contest_user2|
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
		info['handle_1_wins'] = user1_wins
		info['handle_2_wins'] = user2_wins
		info['commonContests'] = commonContests
		aux = info1['contests'] + info2['contests']
		info['contests'] = aux.sort{|a,b| a['ratingUpdateTimeSeconds'] <=> b['ratingUpdateTimeSeconds']}
	end

	# Builds solved problems and attempted contests from a user
	def build_solved_problems_and_attempted_contests (handle)
		entry = UserInformation.where(handle: handle.downcase)[0]
		if entry != nil
			profile_info = entry.info
		else
			profile_info = build_result(handle)
			UserInformation.create(:handle => handle.downcase, :info => profile_info, :updates => 1)
		end
		ac_problems = profile_info['acProblems']
		unsolved_problems = profile_info['unsolvedProblems']
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
	def merge_contests (info1, info2, info)
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
							if handle1 == info1['user']['handle']
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
					if handle1 == info1['user']['handle']
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

	# Calls all the functions above and stores them to the hash "Info" to be returned for a single handle
	def build_result (handle)
		info = Hash.new
		build_user_info(handle, info)
		build_problems(handle, info)
		build_contests(handle, info)
		return info
	end

	# Sets the comparison between two info hashes, i.e. the comparison between two handles
	def build_comparison (info1, info2)
		info = Hash.new
		build_common(info1, info2, info)
		merge_contests(info1, info2, info)
		return info
	end

end