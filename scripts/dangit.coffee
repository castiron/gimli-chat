# Description:
#   Gimli can apologize
#
# Commands:
#   

class DangitUtil
	constructor: (msg) -> 
		@msg = msg
		@names = @msg.message.user.name.split(' ')
	sorry: -> @msg.send "I'm really sorry, #{@names[0]}.  I'll try harder next time..."
	thanks: -> @msg.send "Thanks for the positive feedback, #{@names[0]}!"
	np: -> @msg.send "No problemo, #{@names[0]}!"

module.exports = (robot) ->
	# Can't seem to get whitespace to 
	robot.hear ///(dangit|dammit|sheesh|come on|wow|wtf|wft|omg|crap),?\x20#{robot.name}///i, (msg) -> (new DangitUtil(msg)).sorry()
	robot.hear ///(perf|awesome|exactly|right|nice|wow),?\x20#{robot.name}[!.]?///i, (msg) -> (new DangitUtil(msg)).thanks()
	robot.hear ///(thanks|grazie|gracias|danke|ta),?\x20#{robot.name}[!.]?///i, (msg) -> (new DangitUtil(msg)).np()
