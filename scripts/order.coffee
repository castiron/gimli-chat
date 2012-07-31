module.exports = (robot) ->

	robot.respond  /call it in/i, (msg) ->
    	out = ''
    	for id, user of robot.users()
    		if user.currentOrder
	    		out = out + user.name + ': ' + user.currentOrder + "\n"
    	msg.send out

    robot.respond /clear orders/i, (msg) ->
    	for id, user of robot.users()
   			user.currentOrder = null
    	msg.send "Ok, I've cleared all orders"

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
