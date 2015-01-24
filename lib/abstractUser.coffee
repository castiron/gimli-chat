#############
# Adds/removes users from dish duty
#############
module.exports = class AbstractUser
  constructor: (args) ->
    @r = args.robot
    @user = @getUserByName args.name
    @initialize()

  initialize: ->

  fullHandle: -> @user.name

  getUserByName: (name) -> @r.brain.usersForFuzzyName(name)[0]
