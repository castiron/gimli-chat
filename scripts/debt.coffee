# Description:
#   Keeps track of users' lunch orders
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot (i paid|pay) <person> \$?<amount> - Add a payment into the pool
#
# Author:
#   gblair

# I feel like it will be easier to store only one number (positive or negative)
# for each user pair.  To do this, we create keys in the debts table by 
# concatenating user ids in descending order by convention
# This means we always know which direction the debt points in
# 
# debts = {
# 	'1214753543' : ['12147','53543','12.50']
# }
# TODO: Save the debts at the end of the day somewhere other than the redis database, for backup purposes

module.exports = (robot) ->
	debts = {
		init: (msg) ->
			@msg = msg
			if not robot.brain.data.cicDebts then robot.brain.data.cicDebts = {}
			@debts = robot.brain.data.cicDebts
		addPayment: (positive = true) ->
			amount = @msg.match[3]
			me = @msg.message.user.name.toLowerCase()
			for i,j of @msg.message.user
				@msg.send "K: #{i}, V: #{j}"
			you = debts.findUserByName(@msg.match[2])
			if you
				if positive
					newAmount = @payAmount(amount,me,you)
					@msg.send "Noted. You paid #{you.name} $#{amount}."
				else 
					newAmount = @payAmount(amount,you,me)
					@msg.send "Noted. #{you.name} gave you $#{amount}."
			else
				@msg.send "Sheesh, I can't tell who you mean to pay.  Who the heck is #{@msg.match[2]}!?"
		payAmount: (amount,payor,payee) ->
			# if not payor.id or not payee.id
			# 	@msg.send "I can't figure out who you're talking about, so forget it."
			# 	return
			sorted = [payor.id,payee.id].sort (a,b) -> 
				out = parseInt a > parseInt b
				out = if typeof a is 'undefined' then false else out
			key = "#{sorted[0]}#{sorted[1]}"

			if not @debts[key] then @debts[key] = [sorted[0], (if typeof sorted[1] == 'undefined' then 'nobody' else sorted[1]), 0]
			sign = parseInt(if payor.id is sorted[0] then -1 else 1)
			newAmount = @debts[key][2] + (@roundAmount(amount) * sign)
			if newAmount*1 is 0
				delete @debts[key]
				@msg.send "You two are squared away."
			else
				@debts[key][2] = @roundAmount(newAmount)

		roundAmount: (amount) ->
			out = Math.round(parseFloat(amount)*100)/100

		showAll: ->
			out = ''
			for k,debt of @debts
				creditor = robot.userForId(if (debt[2]*1 < 0) then debt[0] else debt[1])
				debtor = robot.userForId(if (debt[2]*1 < 0) then debt[1] else debt[0])
				amount = Math.abs(debt[2]*1)
				out = out + "#{debtor.name} => #{creditor.name} : $#{amount}\n"
			if not out then out = "Clean slate.  There are no debts."
			@msg.send out

		findUserByName: (name) ->
			userMatches = robot.usersForFuzzyName(name)
			if userMatches.length is 1
				out = userMatches[0]
	}

	robot.respond /dev-debt-trash/i, (msg) ->
		robot.brain.data.cicDebts = {}

	robot.respond /(i )?owe (.*) \$?([0-9\.]*)/i, (msg) ->
		debts.init msg
		debts.addPayment(false)

	robot.respond  /(i paid|pay|give) (.*) \$?([0-9\.]*)/i, (msg) ->
		debts.init msg
		debts.addPayment()

	robot.respond /(show )?debts/i, (msg) ->
		debts.init msg
		debts.showAll()

	robot.respond /settle (debt with )(.*)/i, (msg) ->
		# TODO
		robot.respond "I don't have that skill yet.  In the mean time, just zero it out yourself."