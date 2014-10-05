# Description:
#   Get an outlook for a question, magic eight ball ball style
#
# Commands:
#   hubot outlook <query> - magic eight ball outlook

_ = require 'lodash'
Q = require 'q'

module.exports = (robot) ->
  robot.respond /(outlook)/i, (msg) ->
    name = _.first msg.message.user.name.split ' '
    msg.send getOutlookFor name

  getOutlookFor = (name) ->
    responses = [
      "Signs point to yes, #{name}."
      "Yes."
      "Without a doubt, #{name}."
      "My sources say no, #{name}."
      "As I see it, yes."
      "You may rely on it, #{name}."
      "Outlook not so good, #{name}."
      "It is decidedly so, #{name}."
      "Very doubtful, #{name}."
      "Yes, #{name}, definitely."
      "It is certain."
      "Most likely."
      "My reply is no, #{name}."
      "Outlook good."
      "Don't count on it, #{name}."
      "Yes, in due time."
      "Definitely not."
      "You will have to wait, #{name}."
      "I have my doubts, #{name}."
      "Outlook so so."
      "Looks good to me, #{name}!"
      "Who knows?"
      "Looking good, #{name}!"
      "Probably."
      "Are you kidding, #{name}?"
      "Go for it, #{name}!"
      "Don't bet on it, #{name}."
      "Forget about it, #{name}." ]
    rand = -> Math.ceil Math.random() * responses.length - 1
    responses[rand()]
