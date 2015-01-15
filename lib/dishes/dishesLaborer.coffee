#############
# Adds/removes users from dish duty
#############
module.exports = class DishesLaborer
  constructor: (args) ->
    @r = args.robot
    @user = @getUserByName args.name
    if @user? then @user.dishes ||= {}

  putIntoDuty: -> @user? and (@user.dishes.activeDuty = true)

  removeFromDuty: ->
    if out = @user?
      @user.dishes.activeDuty = false
      true
    else
      false

  getUserByName: (name) -> @r.brain.usersForFuzzyName(name)[0]
