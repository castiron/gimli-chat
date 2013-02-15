# Description:
#   Keeps track of lunch menu URLs
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot add menu <title> <url> - adds a menu item
#	hubot remove menu <title> - removes a menu link
#	hubot (show )?menu <title> - shows the menu link closest matching 
#	hubot (show )?menus - shows all menus in a list
#
# Author:
#   gblair

module.exports = (robot) ->
	menus = {
		init: ->
			if not robot.brain.data.cicMenus then robot.brain.data.cicMenus = {menuList:{}}
			@menus = robot.brain.data.cicMenus.menuList
		add : (key,url) ->
			@menus[@keyify(key)] = url
		getByKey : (key) -> @menus.key
		findClosest : (str) -> @getByKey @keyify str
		keyify : (str) -> str.toUpperCase()
		showAllLinked : (msg) ->
			if Object.keys(@menus).length
				for key,url of @menus
					msg.send key + ": " + url
			else
				msg.send 'There are no menus, human.'
		showAll : (msg) ->
			out = 'There are no menus, human.'
			if Object.keys(@menus).length
				out = ''
				for key,url of @menus
					out = out + "\n" + key + ": " + url
			msg.send out
		removeMenu : (roughKey,msg) ->
			for key,url of @menus
				if key is @keyify(roughKey)
					delete @menus[key]
					return true
			return false
	}

	robot.respond /remove menu (.*)/i, (msg) ->
		if menus.removeMenu(msg.match[1],msg)
			msg.send 'Ok. Removed "' + msg.match[1] + '" from the list of menus.' 
		else 
			msg.send 'Hmm.  Couldn\'t find that one...'

	robot.respond /(show )?menus/i, (msg) ->
		menus.init()
		menus.showAllLinked(msg)

	# robot.respond /menu (.*)/i, (msg) ->
	# 	menus.init()
	# 	url = menus.getByKey(msg.match[1])
	# 	msg.send if url then url else 'I don\'t know what menu you mean, person.'

	robot.respond  /add menu (.*): ?(https?:\/\/.*)/i, (msg) ->
		menus.init()
		msg.send 'Mmmmkay.  Adding menu for ' + menus.keyify(msg.match[1]) + ' with URL ' + msg.match[2]
		menus.add msg.match[1],msg.match[2]



