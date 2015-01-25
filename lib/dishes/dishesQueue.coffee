_ = require 'underscore'
Cronner = require '../util/cronner.coffee'
capitalizeFirst = require '../util/capitalizeFirst.coffee'

#############
# Manages scheduling
#############
module.exports = class DishesQueue
  constructor: (args) ->
    @r = args.robot
    @queueUpdateFrequency = args.queueUpdateFrequency
    @i = @getInitialQueueIndex()
    @initQueueCycle()
    @initialize args

  initialize: (args) ->
    @activeDays = args.activeDays || ['1', '2', '3', '4', '5']
    @cleanersDays = args.cleanersDays || []


  queue: -> _.filter @r.brain.data.users, (v, k) -> v.dishes? and v.dishes.activeDuty

  initQueueCycle: -> new Cronner
    cronTime: @queueUpdateFrequency
    tick: => 
      console.log 'Auto-incrementing DISHES QUEUE'
      @moveQueue()

  currentDayOfWeek: -> (new Date()).getDay()

  todayIsADishesDay: -> _.contains @activeDays, "#{@currentDayOfWeek()}"
  todayIsACleanersDay: -> _.contains @cleanersDays, "#{@currentDayOfWeek()}"
  todayIsAnOffDay: -> !@todayIsADishesDay()
  
  hasAssignee: (queue) -> @getAllAssignees().length > 0

  getAllAssignees: (queue) -> _.filter queue, (i) -> i.dishes.today

  incrementQueue: ->
    q = @queue()
    @i = @getNextQueueIndex()
    if q[@i]?
      q = @resetQueue()
      q[@i].dishes.today = true

  moveQueue: -> if @todayIsADishesDay() then @incrementQueue()
  
  forceMoveQueue: -> @incrementQueue()

  resetQueue: -> 
    out = _.map @queue(), (v) =>
      v.dishes = @initialDishes()
      v
    out

  initialDishes: -> {today: false, activeDuty: true}
  
  getInitialQueueIndex: ->
    allDishes = _.pluck @queue(), 'dishes'
    allTodays = _.pluck allDishes, 'today'
    foundIndex = _.indexOf allTodays, true
    Math.max foundIndex, 0
  
  getNextQueueIndex: -> 
    l = @queue().length
    if l > 1
      if @i + 1 == l then 0 else @i + 1
    else 
      0
  
  getList: -> _.pluck @queue(), 'name'
  
  getPrioritizedList: ->
    l = @getList()
    @arrayChunkToFront l, @i
  
  arrayChunkToFront: (arr, i) -> _.rest(arr, @i).concat _.first(arr, @i)

  getCurrentName: -> 
    item = (_.filter @queue(), (v) -> v.dishes? and v.dishes.today)[0]
    if item? then item.name else undefined
