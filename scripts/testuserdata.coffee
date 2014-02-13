# Description:
#   Simple test of user persistence.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot testUserPersistence - tries to find all persisted users and output their names to you

module.exports = (robot) ->
	robot.respond /testUserPersistence/i, (msg) ->
		out = if robot.brain.users() is undefined
			"TEST FAILED: No users or userdata found.  You should see at least your own user account here, as well as anyone who has been in the system.  It appears they're not getting persisted, though."
		else
			"TEST PASSED!!! Your user data is getting persisted, see?:"
		for id, user of robot.brain.users()
			out = "#{out}\nFOUND: #{user.name.toUpperCase()}"
		msg.send out