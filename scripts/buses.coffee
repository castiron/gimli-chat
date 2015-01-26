TrimetBusDataService = require '../lib/transit/trimetBusDataService.coffee'
TransitInterface = require '../lib/transit/transitInterface.coffee'

# INTERFACE
module.exports = (r) ->
  defaultLocationIds = if process.env.HUBOT_TRIMET_DEFAULT_LOCATION_IDS?
    process.env.HUBOT_TRIMET_DEFAULT_LOCATION_IDS.split ',' 
  else
    ['13689', '13613', '13597']
  new TransitInterface
    robot: r
    dataService: new TrimetBusDataService
      appId: process.env.HUBOT_TRIMET_APP_ID
      defaultLocationIds: defaultLocationIds
