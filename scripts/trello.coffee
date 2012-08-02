# Description:
#   Keeps track of users' lunch orders
#
# Dependencies:
#   "node-trello": "0.1.2"
#
# Configuration:
#   HUBOT_TRELLO_KEY
#	HUBOT_TRELLO_TOKEN
#	HUBOT_BUCKET_CURRENT
#
# Commands:
#   hubot call it in - displays everyone's lunch order
#	hubot clear orders - clears all orders
#	hubot we lunch at <lunchDestination> - sets a lunch destination, which displays on top of the order list
#	hubot order me <lunch> - sets a user's lunch order
#	hubot we share <something to share> sets the shared items
#
# Author:
#   zdavis

module.exports = (robot) ->
	
	robot.respond  /bucket me/i, (msg) ->
		Trello = require "node-trello"
		key = process.env.HUBOT_TRELLO_KEY
		token = process.env.HUBOT_TRELLO_TOKEN
		out = '';
		t = new Trello key, token
		t.get "/1/lists/" + process.env.HUBOT_BUCKET_CURRENT + "/cards", (err, data) ->
  			if err
  				console.log err
  			else
  				for i, card of data
  					msg.send i + '. <a href="' + card.url + '">' + card.name + '</a>'

  				
