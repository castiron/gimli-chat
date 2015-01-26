TabularMessage = require '../util/tabularMessage.coffee'
AbstractHubotInterface = require '../util/abstractInterface.coffee'
TabularMessage = require '../util/tabularMessage.coffee'
unixTimeToHumanTime = require '../util/unixTimeToHumanTime.coffee'

module.exports = class TransitInterface extends AbstractHubotInterface
  #################
  # Setup and utils
  #################

  setup: -> 
    @dataService = @args.dataService
  viaService: (f) ->
    @dataService.once 'ready', f
    @dataService.refresh()

  #################
  # Interface begin
  #################

  # TODO: List (map?) bus arrival times at selected stops
  fullListInterface: ->
    @r.respond /buses/i, (msg) => @viaService =>
      msg.send "Next bus stop arrivals:\n"  + (new TabularMessage @dataService.busArrivals(),
        cols: ['fullSign', 'locationDesc', 'scheduled']
        transform: (row) ->
          ((if row[name]? then row[name] = unixTimeToHumanTime row[name]) for name in ['scheduled', 'estimated'])
          row
        ).formatted()

  # TODO: Show selected stops (on a map? or list)
  selectedStopsInterface: ->
    @r.respond /selected stops/i, (msg) => @viaService =>
      @notImplemented msg

  # TODO: Add a stop to the list of checked ones
  addStopInterface: ->
    @r.respond /add stop ([\d]*)/i, (msg) => @viaService =>
      @notImplemented msg

  # TODO: Add a stop to the list of checked ones
  removeStopInterface: ->
    @r.respond /remove stop ([\d]*)/i, (msg) => @viaService =>
      @notImplemented msg

  # TODO: Show a map (or list) of stops near a location, 
  #  including stop IDs, for easy reference when adding stops
  nearbyStopsInterface: ->
    @r.respond /stops near (.*)/i, (msg) => @viaService =>
      @notImplemented msg
