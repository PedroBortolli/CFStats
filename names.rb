info['ratingDifference']
	= Integer. Rating difference between 2 users

info['commonProblems']
	= Array (of Problem object). List of problems in common between 2 users

info['commonContests']
	= Array (of Contest object). List of contests that both users participated

info['handle1/2'] 
	= Hash. All information about an user (such as handle, name, organization, etc) (not parsed by us, direct from Codeforces API)

info['handle1/2']['uniqueProblems']
	= Array (of Problem object). List of problems that only one of the users solved while the other didnt.

info['handle1/2']['acProblems']
	= Array (of Problem object). List of AC problems by an user

info['handle1/2']['maxRating']
	= Integer. Max rating that an user obtained

info['handle1/2']['minRating']
	= Integer. Min rating that an user obtained

info['handle1/2']['maxUp']
	= Integer. Max increase of rating an user had

info['handle1/2']['maxDown']
	= Integer. Max decrease of rating an user had

info ['handle1/2']['contests']
	= Array (of Contest object). List of Contests that an user participated in

info['handle1/2']['unsolvedProblems']
	= Array (of Problem object). List of problems that an user submitted a solution but never managed to get OK verdict

info['handle1/2']['problemTags']
	= Hash. Count of accepted solutions that an user had for each problem tag



-------------------------------------------------------------------



Problem object (from Codeforces API):
	= Hash.
	problem['index']
		= Integer. Index (A-Z) of a problem
	problem['name']
		= String. Name of a problem
	problem['contestId']
		= Integer. Id of the contest that problem belongs to
	problem['url']       # CUSTOM (not default)
		= String. Url of the problem (custom, made by us)



Contest object (from Codeforces API):
	= Hash.
	contest['contestId']
		= Integer. Id of the contest
	contest['contestName']
		= String. Name of the contest
	contest['handle']
		= String. Name of the participant of the contest
	contest['rank']
		= Integer. Rank that the user obtained
	contest['oldRating']
		= Integer. Rating the user had before the contest
	contest['newRating']
		= Integer. Rating the user had after the contest





