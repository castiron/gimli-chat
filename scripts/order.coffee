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
#	hubot we share <something to share> sets the shared items
#
# Author:
#   zdavis, lthurston

module.exports = (robot) ->

	robot.respond  /call it in/i, (msg) ->
		if robot.brain.data.lunchDestination?
			lunchNotify =  "WE LUNCH AT " + robot.brain.data.lunchDestination.toUpperCase()
			sep = Array(lunchNotify.length + 1).join '-'
			out = "\n" + sep + "\n" + lunchNotify + "\n" + sep + "\n\n"
		else
			out = ''

		hasOrder = false
		for id, user of robot.users()
			if user.currentOrder
				hasOrder = true
				out = out + user.name.toUpperCase() + ': ' + user.currentOrder + "\n"

		if robot.brain.data.orderToShare?
			hasOrder = true
			out = out + "SHARED: " + robot.brain.data.orderToShare + "\n"

		if hasOrder
			msg.send out
		else
			msg.send "I can't call it in if nobody's ordered anything."

	robot.respond /we share (.*)/i, (msg) ->
		orderToShare = msg.match[1]
		robot.brain.data.orderToShare = orderToShare
		msg.send "Ok, you're all gonna share " + orderToShare

	robot.respond /clear orders/i, (msg) ->
		for id, user of robot.users()
			user.currentOrder = null
		robot.brain.data.orderToShare = null
		msg.send "Ok, I've cleared all orders"

	robot.respond /we (lunch|eat)( at)? (.*)/i, (msg) ->
		lunchDestination =  msg.match[3]
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

	robot.respond /we (.*) gorditos/i, (msg) ->
		msg.reply "[ERROR #108XXH820] Failure to comprehend"
		msg.finish
