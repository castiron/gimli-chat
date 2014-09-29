# Description:
#   Get wikipedia summaries
#
# Commands:
#   hubot abstract (me) <query> - Tries to return a description from freebase
#   hubot list (me) <plural query> - Tries to find a list of things from freebase
freebase = require 'freebase'
_ = require 'lodash'
Q = require 'q'

module.exports = (robot) ->
  robot.respond /(list)( me)? (.*)/i, (msg) ->
    query = msg.match[3]
    getList(query)
      .then (val) ->
        msg.send val
      .fail (err) ->
        msg.send err.message
      .done()

  robot.respond /(abstract|abs)( me)? (.*)/i, (msg) ->
    query = msg.match[3]
    getDescription(query)
      .then (val) ->
        msg.send val
      .fail (err) ->
        msg.send err.message
      .done()

getDescription = (query) ->
  deferred = Q.defer()
  freebase.description query, {}, (r) ->
    if !r then deferred.reject new Error "Sorry, I don't know anything about #{query}..."
    else
      # why not append a wikipedia link too:
      response = r + '...'
      freebase.wikipedia_page query, {}, (r) =>
        response += ' ( ' + r + ' )' unless !r
        deferred.resolve response
  deferred.promise

getList = (query) ->
  deferred = Q.defer()
  freebase.list query, {}, (r) ->
    if !r or _.isEmpty r then deferred.reject new Error "Sorry, I don't know any #{query}"
    else
      response = "I know some #{query}: "
      response += _.pluck(r.slice(0, 39), 'name').join ', '
      deferred.resolve response + '...'
  deferred.promise
