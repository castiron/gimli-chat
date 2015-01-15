# Description:
#   Someone must do the dishes at all times!!!
#
# Commands:
#   

CronJob = require('cron').CronJob

class HubotDishes
  constructor: (robot) ->
    @robot = robot
    @init()
  init: -> @cronjob().start()
  
  cronjob: ->
    new CronJob
      cronTime: '* * * * * *',
      onTick: => console.log 'omg omg omg wat'
      start: false,
      timeZone: "America/Los_Angeles"

module.exports = (robot) -> new HubotDishes robot