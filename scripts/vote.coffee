# Description:
#   Allows users to vote for things
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot begin voting on <topic> - begins voting on a topic
#	hubot set votes <vote parameters> - allows the voting parameters to be set (number of up and down votes for each candidate)
#	hubot add candidate <candidate> - adds a candidate to the voting
#	hubot show ballot - shows the ballot
#	hubot vote <candidate> - allows up and down voting of a candidate
#	hubot clear ballot
#	
# Author:
#   lthursto

module.exports = (robot) ->

#	voting = {
#		init: robot ->
#			@.robot = robot
#			@.initListeners()
#	
#		initListeners =>
#			@.robot.respond
#	
#	}
#	voting.init(robot)

	robot.respond /begin voting on (.+)/i, (msg) ->
		# Switches voting
		robot.brain.data.voteTopic = msg.match[1]

		out = 'Ok, you\'re voting on "' + robot.brain.data.voteTopic + '."' 
		msg.send out

	robot.respond /set votes (.+)/i, (msg) ->
		# Adds a number of up and down vote that each individual has
		out = 'Ok, each individual has # up votes and # down votes.'
		msg.send out
		
	robot.respond /add candidate (.+)/i, (msg) ->
		# Adds a candidate
		newCandidate = msg.match[1]
		
		robot.brain.data.voteCandidates ?= Array()
		
		if newCandidate in robot.brain.data.voteCandidates
			out = '"' + newCandidate + '" is already on the ballot, dog!'
		else
			robot.brain.data.voteCandidates.push(newCandidate)
			out = 'Ok, you\'ve added candidate "' + newCandidate + '" to "' + robot.brain.data.voteTopic + '" vote.'

		msg.send out
	
	robot.respond /remove candidate (.+)/i, (msg) ->
		# Removes a candidate
		candidate = msg.match[1]
		
		robot.brain.data.voteCandidates ?= Array()
		
		if candidate in robot.brain.data.voteCandidates
			i = robot.brain.data.voteCandidates.indexOf(candidate)
			robot.brain.data.voteCandidates.splice(i,1) if i >= 0 
			out = 'Ok, you\'ve removed candidate "' + candidate + '" from "' + robot.brain.data.voteTopic + '" vote.'
		else 
			out = 'No se puede, hombre. You can\'t remove what isn\'t there.'
			
		msg.send out

	robot.respond /show ballot/i, (msg) ->
		# Shows the ballot
		out = 'You\'re voting on "' + robot.brain.data.voteTopic + '."' + "\n"
		out = out + 'The candidates are:' + "\n"
		out = out + "\n" + robot.brain.data.voteCandidates.join "\n"
		out = out + "\n"
	
		msg.send out

	robot.respond /clear ballot/i, (msg) ->
		robot.brain.data.voteCandidates = Array()
		
		msg.send 'The ballot is empty.'

	robot.respond /vote (for )?(.+)/i, (msg) ->
		# Placing a vote
		out = 'Ok, you\'ve placed a vote for "______."'
		msg.send out
