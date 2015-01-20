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
    @initDebugReminder()
  
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

  initDebugReminder: ->
    @r.respond /dish(es)? debugReminder/i, (msg) => @sayReminderMsg()

  initReminders: -> new Cronner
    cronTime: @reminderFrequency
    tick: => @sayReminderMsg()

  sayReminderMsg: -> @messager.say @reminderMsg() if @queue.todayIsADishesDay()

  dishDoer: -> capitalizeFirst @queue.getCurrent()

  reminderMsg: -> 
    # NOTE / TODO: "<!channel>" doesn't work with our version of hubot-slack,
    #  due to escaping. Maybs it's been fixed in a newer version?
    # "<!channel>: Oi! You have #{@dishDoer()} to thank for doing the dishes today!"
    "```=-_-= =-_-= =-_-= =-_-= =-_-=\nOi! You have #{@dishDoer()} to thank for doing the dishes today!\n=-_-= =-_-= =-_-= =-_-= =-_-=```"

  userNotFound: (msg) -> msg.send "Sorry wat. No can do!!!!"
