# Description:
#   Keeps track of users' lunch orders
#
# Commands:
#   hubot pay|give <person> <amount> - Add a debt into the debt pool
#   hubot owe|forgive <person> <amount> - Add a debt into the debt pool
#   hubot debts - Show all debts
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
		# No debts to/from these users are allowed
		ignoreUsers: 
			gimli: 1051697
			shell: 1

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
			if me? and you?
				if @isPayable you
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
				else
					@msg.send "No no no.  You can't pay or owe that entity, because it doesn't have pockets."
			else
				@msg.send "No can compute. Sorry."
			@showAll()

		isPayable: (user) ->
			out = true
			if user?
				if user.id?
					for j,id of @ignoreUsers
						out = out && id != user.id
				else 
					out = false
			else
				out = false
			out

		payAmount: (amount,payor,payee) ->
			@payor = payor
			@payee = payee
			if not payor.id or not payee.id
				@msg.send "I can't figure out who you're talking about, so forget it."
				return
			sorted = [@payor.id,@payee.id].sort()
			if (sorted[0]? and sorted[1]?) and (sorted[0] != sorted[1]) # Sanity check - one shouldn't owe oneself...
				@key = "#{sorted[0]}#{sorted[1]}"

				if not @debts[@key] then @debts[@key] = [sorted[0], (if typeof sorted[1] == 'undefined' then 'nobody' else sorted[1]), 0]

				# Get the "direction of this payment (positive or negative)"
				sign = parseInt(if @payor.id is sorted[0] then -1 else 1)

				newAmount = (parseFloat(@debts[@key][2]) + (@roundAmount(amount) * sign)) * 1
				if newAmount is 0
					delete @debts[@key]
					return 0
				else
					@debts[@key][2] = @roundAmount(newAmount)

		roundAmount: (amount) ->
			out = Math.round(parseFloat(amount)*100)/100

		isDebtValid: (debt) -> @isPayable(robot.brain.userForId debt[0]) && @isPayable(robot.brain.userForId debt[1])

		cleanDebts: ->
			for k,debt of @debts
				# Delete user's debts to herself
				if (debt[0] is debt[1]) or (!debt[2]?) then delete @debts[k]

				# Delete debts to/from invalid user ids (e.g. gimli or shell)
				if not @isDebtValid debt then delete @debts[k]

		headerizeForOutput: (str) ->
			if str?
				temp = ''
				for v in str
					temp = "#{temp}-"
				str = "#{str.toUpperCase()}\n#{temp}\n"
			return str

		showAll: (forUser) ->
			@cleanDebts()
			out = ''
			header = ''
			if forUser?
				header = @headerizeForOutput "Debts involving #{forUser.name}:"
				
			for k,debt of @debts
				creditor = robot.brain.userForId(if (debt[2]*1 < 0) then debt[0] else debt[1])
				debtor = robot.brain.userForId(if (debt[2]*1 < 0) then debt[1] else debt[0])
				if forUser? and !((forUser.id == creditor.id) || (forUser.id == debtor.id))
					continue
				amount = Math.abs(debt[2]*1)
				out = out + "#{@getInitialsForUserId debtor.id} => #{@getInitialsForUserId creditor.id}: $#{amount}\n"
			if not out then out = "There are no debts."
			@msg.send header + out

		showMine: ->
			@showAll(@msg.message.user)

		getInitialsForUserId: (id) ->
			out = robot.brain.userForId(id).name
			names = out.split(' ')
			if names.length is 2
				out = "#{names[0].charAt(0)}#{names[1].charAt(0)}"
			return out

		findUserByName: (name) ->
			userMatches = robot.brain.usersForFuzzyName(name)
			if userMatches.length is 1
				out = userMatches[0]
	}

	robot.respond /explain debts?/i, (msg) ->
		msg.send "Usage examples:\ngimli pay|give|lend|< lucas 12\ngimli owe|forgive|> toshiro $16"

	robot.respond /dev-debt-trash/i, (msg) ->
		robot.brain.data.cicDebts = {}

	robot.respond /(i )?owe (.*) \$?([\d.]+)/i, (msg) ->
		debts.init msg
		debts.addPayment(false)

	robot.respond /(show )?my debts?/i, (msg) ->
		debts.init msg
		debts.showMine()

	robot.respond /(i )?forg[ia]ve (.*) \$?([\d.]+)/i, (msg) ->
		debts.init msg
		debts.addPayment(false)

	robot.respond  /(i paid|pay|give|lend) (.*) \$?([\d.]+)/i, (msg) ->
		debts.init msg
		debts.addPayment()

	robot.respond  /(<) (.*) \$?([\d.]+)/i, (msg) ->
		debts.init msg
		debts.addPayment()

	robot.respond  /(>) (.*) \$?([\d.]+)/i, (msg) ->
		debts.init msg
		debts.addPayment(false)

	robot.respond /(show )?debts/i, (msg) ->
		debts.init msg
		debts.showAll()

	# robot.respond /settle (debt with )(.*)/i, (msg) ->
	# 	# TODO
	# 	robot.respond "I don't have that skill yet.  In the mean time, just zero it out yourself."