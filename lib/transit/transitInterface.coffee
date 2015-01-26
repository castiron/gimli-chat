TabularMessage = require '../util/tabularMessage.coffee'
AbstractHubotInterface = require '../util/abstractInterface.coffee'
unixTimeToHumanTime = require '../util/unixTimeToHumanTime.coffee'
F = require '../util/messageFormatter.coffee'

# TODO: Store selected stops, etc. in the brain to rehydrate next time
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
      res = (new TabularMessage @dataService.busArrivals(),
        cols: ['fullSign', 'direction', 'locationDesc', 'scheduled']
        # TODO: this belongs closer to (or in, for now) the dataService object
        #  probs best to keep transform responsibility out of the table fomatter :sweat_smile:
        transform: (row) ->
          ((if row[name]? then row[name] = unixTimeToHumanTime row[name]) for name in ['scheduled', 'estimated'])
          row
        ).formatted()
      msg.send "Upcoming buses:\n"  + F.codeBlock(res)

  howToGetStopIds: -> 'To get stop IDs, go to http://ride.trimet.org/ and zoom in far enough so you can hover the little dots for each stop'

  # TODO: Show selected stops (on a map? or list)
  selectedStopsInterface: ->
    @r.respond /selected stops/i, (msg) => @viaService =>
      msg.send "These stops are currently selected:\n"  + F.codeBlock (new TabularMessage @dataService.locations, {cols: ['desc'], header: false}).formatted()

  # TODO: Add a stop to the list of checked ones
  addStopInterface: ->
    @r.respond /add stop ([\d]*)/i, (msg) => @viaService =>
      @notImplemented msg
      msg.send @howToGetStopIds()

  # TODO: Add a stop to the list of checked ones
  removeStopInterface: ->
    @r.respond /remove stop ([\d]*)/i, (msg) => @viaService =>
      @notImplemented msg
      msg.send @howToGetStopIds()

  # TODO: Show a map (or list) of stops near a location, 
  #  including stop IDs, for easy reference when adding stops
  nearbyStopsInterface: ->
    @r.respond /stops near (.*)/i, (msg) => @viaService =>
      @notImplemented msg
