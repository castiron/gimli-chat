# Description:
#   Reminds us that the endtimes are approaching
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#
#
# Author:
#   cybergod

module.exports = (robot) ->
	robot.hear /cybergeddon/i, (msg) ->
		doomsday = [
			'KLAMMICHES FOR LUNCH',
			'ALEX WALKS OVER TO MY DESK',
			'THE NEXT DADZ SHREDFEST',
			'GABE LOGS HIS COMMUTES',
			'NICK SAYS "PASTOR [INSERT DAY OF WEEK]"',
			'ROMNEY TURNS INTO A REAL BOY',
			"I'LL NEVER TELL!!! MWWAAAAHAHAHAAAAA",
			'I POOSH A BUTTON',
			'THE IPHONE 22 IS RELEASED',
			'NETOP\'S SVN SERVER WORKS AGAIN',
			'TUCKER CHEWS ZACH\'S ELBOW OFF',
			'CYBERGEDDON!!!!!!!!!',
			'MASSIVE EARTHQUAKE NARROWLY MISSES PORTLAND',
		]
		
		remaining = new Date('09/25/2012 12:00') - new Date()
		oneDay = 1000 * 60 * 60 * 24
		oneHour = 1000 * 60 * 60
		oneMinute = 1000 * 60
		oneSecond = 1000
		daysLeft = Math.floor(remaining / oneDay)
		remaining -= (daysLeft * oneDay)
		hoursLeft = Math.floor(remaining / oneHour)
		remaining -= (hoursLeft * oneHour)
		minutesLeft = Math.floor(remaining / oneMinute)
		remaining -= (minutesLeft * oneMinute)
		secondsLeft = Math.floor(remaining / oneSecond)

		setTimeout(->
			msg.send '     '+daysLeft+' days'
		,1000)
		setTimeout(->
			msg.send '     '+hoursLeft+' hours'
		,2000)
		setTimeout(->
			msg.send '     '+minutesLeft+' minutes'
		,3500)
		setTimeout(->
			msg.send '     '+secondsLeft+' seconds'
		,7000)
		setTimeout(->
			msg.send '     ...until...'
		,11000)
		setTimeout(->
			msg.send '     '+doomsday[Math.floor(Math.random() * doomsday.length)]
		,16000)
