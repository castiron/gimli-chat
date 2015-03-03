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
#   hubot i'm working on <task> - Sets current task for user
#   hubot what is <user> working on? - Reports current user's task
#   hubot what are we working on? - Reports tasks set by all users
#
# Author:
#   naomi based on orders by zdavis, lthurston, gblair

module.exports = (robot) ->

	robot.respond  /what are we working on\??/i, (msg) ->
    anybodyWorking = false
    out = ''

    for id, user of robot.brain.users()
      if user.currentProj
        anybodyWorking = true
        out = out + user.name.toUpperCase() + ' is on: ' + user.currentProj.name + ' || ' + user.currentProj.time

    if anybodyWorking
      msg.send out
    else
      msg.send ":whoosh: :wind_chime: :sunrise_over_mountains:"

	robot.respond /(what is|waht is) (.*) (working on\??)/i, (msg) ->
    userName = msg.match[2]
    users = robot.brain.usersForFuzzyName(userName)
    if users.length is 1
      user = users[0]
      if user.currentProj
        out = "As of: " + user.currentProj.time + ", " + userName + " is working on " + user.currentProj.name + "."
        currentTime = new Date()
        if currentTime - user.currentProj.time >= 203828883
          out = out + "\n That was quite a while ago, though :leaves:"
      else
        out = userName + " is staring blankly into the shadows..."
      msg.send out

	robot.respond  /(i'?m working on) (.*)/i, (msg) ->
		userName = msg.message.user.name.toLowerCase()
		userProj = msg.match[2]
		if userProj
			users = robot.brain.usersForFuzzyName(userName)
			if users.length is 1
        user = users[0]
        user.currentProj = {
          name: userProj,
          time: new Date()
        }
        out = "Got it. As of: " + user.currentProj.time + ", " + userName + " is working on " + userProj + "."
        msg.send out


