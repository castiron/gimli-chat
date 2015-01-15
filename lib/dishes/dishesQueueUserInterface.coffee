capitalizeFirst = require '../util/capitalizeFirst.coffee'
Cronner = require '../util/cronner.coffee'

#############
# UI to the dish queue
#############
module.exports = class DishesQueueUserInterface
  constructor: (args) ->
    @r = args.robot
    @reminderFrequency = args.reminderFrequency
    @messager = args.messager
    @LaborerModule = args.laborerModule
    @queue = args.queue
    @initUserAdd()
    @initUserRemove()
    @initList()
    @initReminders()
  
  initUserAdd: ->
    @r.respond /dish(es)?( queue)? (add|activate) ([^\s]+)/i, (msg) =>
      name = msg.match[4]
      if (new @LaborerModule {robot: @r, name: name}).putIntoDuty()
        msg.send "All right, I've added #{capitalizeFirst name} to the dish rotation"
      else
        @userNotFound msg
  
  initUserRemove: ->
    @r.respond /dish(es)?( queue)? (remove|deactivate) ([^\s]+)/i, (msg) =>
      name = msg.match[4]
      if (new @LaborerModule {robot: @r, name: name}).removeFromDuty()
        msg.send "All right, I've removed #{capitalizeFirst name} from the dish rotation"
      else 
        @userNotFound msg

  initList: -> @r.respond /dish(es)( queue)?$/i, (msg) => @showList msg

  showList: (msg) -> 
    res = 'No one is scheduled to do the dishes...:scream:'
    l = @queue.getPrioritizedList()
    if l.length > 0 
      l[0] = "#{l[0]} (today)"
      list = l.join "\n"
      res =  "```The dishes queue:\n#{list}```"
    msg.send res

  initReminders: -> new Cronner
    cronTime: @reminderFrequency
    tick: => @messager.say @reminderMsg() if @queue.todayIsADishesDay()

  dishDoer: -> capitalizeFirst @queue.getCurrent()

  reminderMsg: -> "@channel: Oi! You have #{@dishDoer()} to thank for doing the dishes today!"

  userNotFound: (msg) -> msg.send "Sorry wat. No can do!!!!"
