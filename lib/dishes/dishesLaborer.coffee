AbstractUser = require '../abstractUser.coffee'

#############
# Adds/removes users from dish duty
#############
module.exports = class DishesLaborer extends AbstractUser
  initialize: -> if @user? then @user.dishes ||= {}

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
