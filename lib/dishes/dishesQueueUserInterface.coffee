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
      laborer = new @LaborerModule {robot: @r, name: name}
      msg.send if laborer.putIntoDuty()
        "All right, I've added #{capitalizeFirst laborer.fullHandle()} to the dish rotation"
      else
        @userNotFoundMsg()
  
  initUserRemove: ->
    @r.respond /dish(es)?( queue)? (remove|deactivate) ([^\s]+)/i, (msg) =>
      name = msg.match[4]
      laborer = new @LaborerModule {robot: @r, name: name}
      msg.send if laborer.removeFromDuty()
        "All right, I've removed #{capitalizeFirst laborer.fullHandle()} from the dish rotation"
      else
        @userNotFoundMsg()

  initList: -> @r.respond /dish(es)( queue)?$/i, (msg) => @showList msg

  showList: (msg) ->
    res = @noOneMsg()
    l = @queue.getPrioritizedList()
    if @queue.todayIsAnOffDay() then l.unshift @offDayMsg()
    if @queue.todayIsACleanersDay() then l.unshift @cleanersName()
    if l.length > 0
      l[0] = "#{capitalizeFirst l[0]} (today)"
      list = l.join "\n"
      res =  "```The dishes queue:\n#{list}```"
    msg.send res

  initDebugReminder: ->
    @r.respond /dish(es)? debugReminder/i, (msg) => @messager.say @reminderMsg() 

  initReminders: -> new Cronner
    cronTime: @reminderFrequency
    tick: => @sayReminderMsg()

  sayReminderMsg: -> @messager.say @reminderMsg() if @queue.todayIsADishesDay()

  dishDoer: ->
    nobody = 'Nobody'
    switch
      when @queue.todayIsACleanersDay() then @cleanersName()
      when @queue.todayIsAnOffDay() then nobody
      else 
        c = @queue.getCurrentName()
        if c? then c else nobody

  reminderMsg: -> 
    # NOTE / TODO: "<!channel>" doesn't work with our version of hubot-slack,
    #  due to escaping. Maybs it's been fixed in a newer version?
    # "<!channel>: Oi! You have #{@dishDoer()} to thank for doing the dishes today!"
    "```=-_-= =-_-= =-_-= =-_-= =-_-=\nOi! You have #{capitalizeFirst @dishDoer()} to thank for doing the dishes today!\n=-_-= =-_-= =-_-= =-_-= =-_-=```"

  noOneMsg: -> 'No one is scheduled to do the dishes...:scream:'

  cleanersName: -> 'CLEANERS'

  offDayMsg: -> 'NOTE: The dishes wheel does not turn today'

  userNotFoundMsg: -> "Sorry wat. No can do!!!!"
