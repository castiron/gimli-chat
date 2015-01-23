#############
# Adds/removes users from dish duty
#############
module.exports = class DishesLaborer
  constructor: (args) ->
    @r = args.robot
    @user = @getUserByName args.name
    if @user? then @user.dishes ||= {}

  putIntoDuty: -> 
    if @user?
      @user.dishes.activeDuty = true
      @user.dishes.today = false
      true
    else
      false

  removeFromDuty: ->
    if @user?
      @user.dishes.activeDuty = false
      @user.dishes.today = false
      true
    else
      false

  fullHandle: -> @user.name

  getUserByName: (name) -> @r.brain.usersForFuzzyName(name)[0]
