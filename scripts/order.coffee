module.exports = (robot) ->

	robot.respond  /call it in/i, (msg) ->
    	out = ''
    	users = robot.users()
    	for id, user of users
    		if user.currentOrder
	    		out = out + user.name + ': ' + user.currentOrder + "\n"
    	msg.send out


	robot.respond  /(order)( me)? (.*)/i, (msg) ->
		userName = msg.message.user.name.toLowerCase()
		userWants = msg.match[3]
		if userWants
			users = robot.usersForFuzzyName(userName)
			msg.send "Test!"
			if users.length is 1
	        	user = users[0]
	        	user.currentOrder = userWants
	        	out = "Ok, " + userName + ", you want " + userWants
				msg.send out
