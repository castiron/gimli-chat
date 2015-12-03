# Description:
#   Keep track of users' current projjies and tasks
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
# hubot I'm working on/doing <project> - Set current project
#	hubot I'm done - Clear current project
# hubot What am I working on/doing? - Output what active user is doing
#	hubot What is <user> working on/doing? - Output what named user is doing
#	hubot What is everyone working on/doing? - Output a list of all user project records
#
# Author:
#   Naomi Rubin based off of Lunch Order script by zdavis, lthurston, gbl
#
# TODO:
#   - Implement some kind of optional task parsing such that a structured list can be stored instead of arbitrary text for
#     a user's project record
#   - Add a function that allows any user to reorder the listed tasks of another user

module.exports = (robot) ->
  robot.respond /(projjy report)|((what|waht) is (everyone|everybody) (working on|doing)\??)/i, (msg) ->
    today = new Date()
    out = 'Projjical Listing for ' + today.toString() + '\n--------------------\n\n'
    anyProjjies = false
    for id, user of robot.brain.users()
      if user.currentProjjies
        anyProjjies = true
        out = out + user.name.toUpperCase() + ": " + user.currentProjjies + "\n"

    if anyProjjies
      msg.send out
    else
      msg.send out + 'MARIKO D CLIFFNOTES MCGILLICUTTY: United Sumo Federation Footer Slider Markup\nIDA: ADD OR REMOVE YEARLING\nLUCAS: ¿Cuantós Car2Gos Hay en El Mundo, cuantós?'


  robot.respond /(what|waht) is (.*) (working on|doing)\??/i, (msg) ->
    userName = msg.match[2].toLowerCase()
    users = robot.brain.usersForFuzzyName(userName)
    if users.length is 1
      user = users[0]
      if user.currentProjjies == null or user.currentProjjies == undefined
        msg.send userName + " isn't working on anything right yet."
      else
        msg.send userName + " is working on " + user.currentProjjies

  robot.respond /(what|waht) am i (working on|doing)\??/i, (msg) ->
    userName = msg.message.user.name.toLowerCase()
    users = robot.brain.usersForFuzzyName(userName)
    if users.length is 1
      user = users[0]
      if user.currentProjjies
        msg.send userName + " you are working on " + user.currentProjjies
      else
        msg.send userName + " you haven't logged any projjies yet, or maybe you're done!!! :taconom: :taconom:"

  robot.respond /(i'm|im) done/i, (msg) ->
    userName = msg.message.user.name.toLowerCase()
    users = robot.brain.usersForFuzzyName(userName)
    if users.length is 1
      user = users[0]
      user.currentProjjies = null
      msg.send "Congrats, :clap: " + userName + "! Your projjy list is clear."

  robot.respond  /(i'm|im) (working on|doing) (.*)/i, (msg) ->
    userName = msg.message.user.name.toLowerCase()
    userProjjies = msg.match[3]
    if userProjjies
      users = robot.brain.usersForFuzzyName(userName)
      if users.length is 1
        user = users[0]
        user.currentProjjies = userProjjies
        out = "Thanks " + userName + ". Your projjies have been logged."
        msg.send out


