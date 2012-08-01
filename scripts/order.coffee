# Description:
#   Keeps track of users' lunch orders
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot call it in - displays everyone's lunch order
#	hubot clear orders - clears all orders
#	hubot we lunch at <lunchDestination> - sets a lunch destination, which displays on top of the order list
#	hubot order me <lunch> - sets a user's lunch order
#
# Author:
#   jmoses

module.exports = (robot) ->

	robot.respond  /call it in/i, (msg) ->

		if robot.brain.data.lunchDestination?
	    	out = "\n" + '--------------------------------' + "\n WE LUNCH AT " + robot.brain.data.lunchDestination.toUpperCase() + "\n" + '--------------------------------' + "\n\n"
	    else
	    	out = ''

    	hasOrder = false
    	for id, user of robot.users()
    		if user.currentOrder
    			hasOrder = true
	    		out = out + user.name.toUpperCase() + ': ' + user.currentOrder + "\n"
	    if hasOrder
	    	msg.send out
	    else
	    	msg.send "I can't call it in if nobody's ordered anything."

    robot.respond /clear orders/i, (msg) ->
    	for id, user of robot.users()
   			user.currentOrder = null
    	msg.send "Ok, I've cleared all orders"

	robot.respond /we lunch( at)? (.*)/i, (msg) ->
    	lunchDestination =  msg.match[2]
    	robot.brain.data.lunchDestination = lunchDestination
    	msg.send "Ok, we lunch at " + robot.brain.data.lunchDestination

	robot.respond  /(order)( me)? (.*)/i, (msg) ->
		userName = msg.message.user.name.toLowerCase()
		userWants = msg.match[3]
		if userWants
			users = robot.usersForFuzzyName(userName)
			if users.length is 1
	        	user = users[0]
	        	user.currentOrder = userWants
	        	out = "Ok, " + userName + ", you want " + userWants
				msg.send out
