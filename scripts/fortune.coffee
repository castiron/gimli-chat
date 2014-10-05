# Description:
#   Get a fortune a la emojifortun.es
#
# Commands:
#   hubot fortune - Generates an emoji fortune

_ = require 'lodash'
Q = require 'q'

module.exports = (robot) ->
  if !robot.slack
    Slack = require 'slack-node'
    robot.slack = new Slack process.env.HUBOT_SLACK_API_TOKEN

  robot.respond /(fortune)(.*)/i, (msg) ->
    fetchEmoji()
      .then (emoji) ->
        fortune = ''
        rand = -> Math.ceil Math.random() * emoji.length - 1
        fortune += ':' + emoji[rand()] + ': ' for [1..3]
        msg.send fortune
      .fail ->
        msg.send ':finnadie: :finnadie: :finnadie:'
      .done()

  fetchEmoji = ->
    deferred = Q.defer()
    robot.slack.api 'emoji.list', (err, res) ->
      if not res.ok then deferred.reject()
      arr = []
      for ji of res.emoji
        arr.push ji
      deferred.resolve arr
    deferred.promise

