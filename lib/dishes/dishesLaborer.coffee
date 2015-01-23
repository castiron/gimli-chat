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
      @resetUser()
      @user.dishes.activeDuty = true
      true
    else
      false

  removeFromDuty: ->
    if @user?
      @resetUser()
      true
    else
      false

  resetUser: ->
    @user.dishes.activeDuty = false
    @user.dishes.today = false

  fullHandle: -> @user.name

  getUserByName: (name) -> @r.brain.usersForFuzzyName(name)[0]
