TrimetBusDataService = require '../lib/transit/trimetBusDataService.coffee'
TransitInterface = require '../lib/transit/transitInterface.coffee'

# INTERFACE
module.exports = (r) ->
  new TransitInterface
    robot: r
    # formatter: new BusDataFormatter
    dataService: new TrimetBusDataService
      appId: '838728B06B7791BD7ABA6D657'
      defaultLocationIds: ['13689', '13613', '13597']
  
