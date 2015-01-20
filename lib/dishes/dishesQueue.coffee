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
    @activeDays = args.activeDays || ['2', '3', '4', '5', '6']
    @messager = args.messager
    @i = @getInitialQueueIndex()
    @initQueueCycle()

  queue: -> 
    queue = []
    queue = _.filter @r.brain.data.users, (v, k) -> v.dishes? and v.dishes.activeDuty
    if queue.length > 0 and !@hasAssignee(queue)
      queue[0].dishes.today = true
    queue

  initQueueCycle: -> new Cronner
    cronTime: @queueUpdateFrequency
    tick: => @moveQueue()

  todayIsADishesDay: -> (_.indexOf @activeDays, "#{(new Date()).getDay()}") != -1
  
  hasAssignee: (queue) -> (
      _.filter queue, (i) -> i.dishes.today
    ).length > 0
  
  moveQueue: -> if @todayIsADishesDay()
    q = @queue()
    @i = @getNextQueueIndex()
    if q[@i]?
      q = @resetQueue()
      q[@i].dishes ||= {}
      q[@i].dishes.today = true
  
  resetQueue: -> _.map @queue(), (v) ->
    v.dishes.today = false
    v
  
  # There's got to be a better way to do this
  getInitialQueueIndex: -> 
    i = 0
    j = 0
    found = false
    _.each @queue(), (v) -> 
      if !found and v.dishes? and v.dishes.today? and v.dishes.today then i = j
      j++
    i
  
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

  getCurrent: -> 
    item = (_.filter @queue(), (v) -> v.dishes? and v.dishes.today)[0]
    if @todayIsADishesDay()
      if item? then capitalizeFirst item.name else 'er...nobody'
    else
      'the Cleaners'