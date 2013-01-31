# Description:
#   Keeps track of quill orders
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot show quill order - shows the quill order
#	hubot clear quill order
#	hubot quill order <item> adds an item to the quill order
#
# Author:
#   zdavis, lthurston, gblair

module.exports = (robot) ->	
	robot.respond  /show quill( order)?/i, (msg) ->
		if not robot.brain.data.quillOrder then robot.brain.data.quillOrder = []
		out = ''
		hasOrder = false
		for id, item of robot.brain.data.quillOrder
			hasOrder = true
			out = out + (parseInt(id,10)+1) + '. ' + item + "\n"

		if hasOrder
			msg.send out
		else
			msg.send "There's nothing in the Quill order, so..."
	
	robot.respond /remove (\d*) from quill/i, (msg) ->
		key = msg.match[1] - 1
		if key > -1 and robot.brain.data.quillOrder[key]
			msg.send "Removing \"" + robot.brain.data.quillOrder[key] + "\" from the order"
			delete robot.brain.data.quillOrder[key]
			temp = []
			for id,item of robot.brain.data.quillOrder
				if item then temp.push item
			robot.brain.data.quillOrder = temp
		else
			msg.send "I don't think that's really an item in the order, so forget it."

	robot.respond /clear quill( orders?)?/i, (msg) ->
		robot.brain.data.quillOrder = []
		msg.send "Ok, I've cleared the Quill order"

	robot.respond  /quill( order( me)?)? (.*)/i, (msg) ->
		# Avoid confusion in command syntax.  Though "quill it in" is an interesting phrase, there is no such command, for now.
		if /it in/i.test(msg.match[3]) 
			msg.send "You want me to add \"it in\" to the list? Fuck that."
			return
		# TODO: check for perceived URL and shorten it with a service if it's longer than n characters
		if not robot.brain.data.quillOrder then robot.brain.data.quillOrder = []
		userWants = msg.match[3]
		if userWants
			robot.brain.data.quillOrder.push userWants.substr(0, 1).toUpperCase() + userWants.substr(1)
			msg.send "Ok, I've added " + userWants + " to the Quill order"
		else
			msg.send "I can't tell what you want, so forget it."