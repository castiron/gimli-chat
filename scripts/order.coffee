module.exports = (robot) ->
	robot.respond /order me/i, (msg) ->
		msg.send "You said: " + msg