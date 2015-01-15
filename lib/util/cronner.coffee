CronJob = require('cron').CronJob

#################
# Cheapy little cron wrapper
#################
module.exports = class Cronner
  constructor: (args) ->
    @args = args
    @start()
  
  start: ->
    new CronJob
      cronTime: @cronTime()
      onTick: => @tick()
      start: true
      timeZone: @timeZone()
  
  timeZone: -> @args.timeZone || "America/Los_Angeles"
  
  cronTime: -> @args.cronTime || '0 0 * * * *'
  
  tick: -> @args.tick()
