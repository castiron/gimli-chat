# Description:
#   Gimli can apologize
#
# Commands:
#   

module.exports = (robot) ->
	# Can't seem to get whitespace to 
	robot.hear ///(dangit|dammit|sheesh|come on|wow),?\x20#{robot.name}///i, (msg) ->
		names = msg.message.user.name.split(' ')
		msg.send "I'm really sorry, #{names[0]}.  I'll try harder next time..."

