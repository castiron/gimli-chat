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
			'LUNCHTIME',
			'THE RAPTURE',
			'ALIEN INVASION',
			'THE COMMIES ATTACK!',
			'CHINA TAKES OVER THE WORLD',
			'ROMNEY SAYS SOMETHING STUPID, AGAIN',
			"I'LL NEVER TELL!!! MWWAAAAHAHAHAAAAA",
			'CYBERGEDDON',
			'CAPTAIN PICARD TURNS INTO A BORG',
			'STEVE JOBS RETURNS FROM THE DEAD',
			'TUCKER COMES HOME',
			'CYBERGEDDON',
			'MASSIVE EARTHQUAKE ENGULFS PORTLAND',
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
