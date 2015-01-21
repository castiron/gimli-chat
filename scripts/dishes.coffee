# Description:
#   Someone must do the dishes at all times!!! This thing will remind people
#
# Commands:
#   hubot dish queue add <person> - Add a user to the dishes labor pool
#   hubot dish queue remove <person> - Remove a user from the dishes labor pool
#   hubot dishes - Show who's doing the dishes today
#   hubot show dish(es)? (queue|pool) - Show the dishes labor pool
#
# Configuration:
#   HUBOT_DISHES_ROOM - Slack room ID for the room in which to announce dish duties
#   HUBOT_DISHES_REMINDER_CRON_FREQUENCY - A cron frequency descriptor to control when reminders happen
#   HUBOT_DISHES_UPDATE_CRON_FREQUENCY - A cron frequency descriptor to control when the queue flips over
#
# Author:
#   gblair

# TODO: Add fallback disher-doer

DishesQueue = require '../lib/dishes/dishesQueue.coffee'
DishesLaborer = require '../lib/dishes/dishesLaborer.coffee'
DishesQueueUserInterface = require '../lib/dishes/dishesQueueUserInterface.coffee'
RoomMessager = require '../lib/util/roomMessager.coffee'

# SET UP YE DISHES
module.exports = (r) -> r.brain.on 'loaded', ->
  messager = new RoomMessager
    robot: r
    roomId: if process.env.HUBOT_DISHES_DEV > 0 then process.env.HUBOT_DISHES_ROOM_DEV else process.env.HUBOT_DISHES_ROOM
  new DishesQueueUserInterface 
    robot: r
    messager: messager
    reminderFrequency: process.env.HUBOT_DISHES_REMINDER_CRON_FREQUENCY
    laborerModule: DishesLaborer
    queue: new DishesQueue 
      robot: r
      queueUpdateFrequency: process.env.HUBOT_DISHES_UPDATE_CRON_FREQUENCY
      messager: messager
      activeDays: ['1', '2', '3', '4', '5']
      cleanersDays: ['2']
