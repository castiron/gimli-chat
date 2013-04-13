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
# TODO: Show debts using initials
# TODO: Save the debts at the end of the day somewhere other than the redis database, for backup purposes
# TODO: Maintain a list of debts for each user, for easier listing by user?  Maybs we need a real database somehow on here.
# TODO: Store a timestamp on each stored debt object.  If two transactions are tried within n seconds, throw an error for the second one
module.exports = (robot) ->
	debts = {
		init: (msg) ->
			@msg = msg
			if not robot.brain.data.cicDebts then robot.brain.data.cicDebts = {}
			@debts = robot.brain.data.cicDebts
		addPayment: (positive = true) ->
			amount = @msg.match[3]
			if amount > 100
				@msg.send "That's arbitrarily too much - forget it!"
				return
			me = @msg.message.user
			you = @findUserByName(@msg.match[2])
			if me.id is you.id
				@msg.send "Yeah yeah no.  Paying yourself has no effect."
				return
			if you
				if positive
					newAmount = @payAmount(amount,me,you)
					message = "Noted. You paid #{you.name} $#{amount}."
				else 
					newAmount = @payAmount(amount,you,me)
					message = "Noted. #{you.name} gave you $#{amount}."
				extra = if newAmount is 0 then "  You two are squared away." else ""
				@msg.send message + extra
			else
				@msg.send "Sheesh, I can't make head or tail of what you want. Forget it."
		payAmount: (amount,payor,payee) ->
			# TODO: Shouldn't be able to pay Gimli
			@payor = payor
			@payee = payee
			if not payor.id or not payee.id
				@msg.send "I can't figure out who you're talking about, so forget it."
				return
			sorted = [@payor.id,@payee.id].sort (a,b) -> b - a
				
			@key = "#{sorted[0]}#{sorted[1]}"

			if not @debts[@key] then @debts[@key] = [sorted[0], (if typeof sorted[1] == 'undefined' then 'nobody' else sorted[1]), 0]

			# Get the "direction of this payment (positive or negative)"
			sign = parseInt(if @payor.id is sorted[0] then -1 else 1)

			newAmount = (@debts[@key][2] + (@roundAmount(amount) * sign)) * 1
			if newAmount is 0
				delete @debts[@key]
				return 0
			else
				@debts[@key][2] = @roundAmount(newAmount)

		roundAmount: (amount) ->
			out = Math.round(parseFloat(amount)*100)/100

		showAll: ->
			out = ''
			for k,debt of @debts
				creditor = robot.userForId(if (debt[2]*1 < 0) then debt[0] else debt[1])
				debtor = robot.userForId(if (debt[2]*1 < 0) then debt[1] else debt[0])
				amount = Math.abs(debt[2]*1)
				out = out + "#{@getInitialsForUserId debtor.id} => #{@getInitialsForUserId creditor.id}: $#{amount}\n"
			if not out then out = "Clean slate.  There are no debts."
			@msg.send out

		getInitialsForUserId: (id) ->
			out = robot.userForId(id).name
			names = out.split(' ')
			if names.length is 2
				out = "#{names[0].charAt(0)}#{names[1].charAt(0)}"
			return out

		findUserByName: (name) ->
			userMatches = robot.usersForFuzzyName(name)
			if userMatches.length is 1
				out = userMatches[0]
	}

	robot.respond /explain debts?/i, (msg) ->
		msg.send "Usage examples:\ngimli pay|give|lend|< lucas 12\ngimli owe|forgive|> alex $16"

	robot.respond /dev-debt-trash/i, (msg) ->
		robot.brain.data.cicDebts = {}

	robot.respond /(i )?owe (.*) \$?([0-9\.]*)/i, (msg) ->
		debts.init msg
		debts.addPayment(false)

	robot.respond /(i )?forg[ia]ve (.*) \$?([0-9\.]*)/i, (msg) ->
		debts.init msg
		debts.addPayment(false)

	robot.respond  /(i paid|pay|give|lend) (.*) \$?([0-9\.]+)/i, (msg) ->
		debts.init msg
		debts.addPayment()

	robot.respond  /(<) (.*) \$?([0-9\.]+)/i, (msg) ->
		debts.init msg
		debts.addPayment()

	robot.respond  /(>) (.*) \$?([0-9\.]+)/i, (msg) ->
		debts.init msg
		debts.addPayment(false)

	robot.respond /(show )?debts/i, (msg) ->
		debts.init msg
		debts.showAll()

	# robot.respond /settle (debt with )(.*)/i, (msg) ->
	# 	# TODO
	# 	robot.respond "I don't have that skill yet.  In the mean time, just zero it out yourself."