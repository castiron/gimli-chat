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
		keyify : (str) -> str.toUpperCase()
		showAll : (msg) ->
			out = 'There are no menus, human.'
			if Object.keys(@menus).length
				out = '||---/// THE MENUS \\\\\\---||'
				for key,url of @menus
					out = out + "\n" + key + ":\t\t" + url
			msg.send out
		removeMenu : (roughKey,msg) ->
			for key,url of @menus
				if key is @keyify(roughKey)
					msg.send 'Removing ' + key
					delete @menus[key]
					return true
			return false
	}

	robot.respond /remove menu (.*)/i, (msg) ->
		if menus.removeMenu(msg.match[1],msg) then msg.send 'Ok. Removed it.' else msg.send 'Hmm.  Couldn\'t find that one'

	robot.respond /(show )?menus/i, (msg) ->
		menus.init()
		menus.showAll(msg)

	robot.respond  /add menu (.*): ?(https?:\/\/.*)/i, (msg) ->
		menus.init()
		msg.send 'Mmmmkay.  Adding menu for ' + menus.keyify(msg.match[1]) + ' with URL ' + msg.match[2]
		menus.add msg.match[1],msg.match[2]



