http = require 'http'
_ = require 'underscore'
EventEmitter = require('events').EventEmitter

# DATA FETCHER
# TODO: Break this out into separate objects for each type of data
module.exports = class TrimetBusDataService extends EventEmitter
  constructor: (args) ->
    @appId = args.appId
    @locIds = args.defaultLocationIds
    @getData()

  path: -> '/ws/v2/arrivals'
  queryParams: -> "appID=#{@appId}&json=true&streetcar=false&locIDs=#{@locIds}&showPosition=true"
  uri: -> "#{@path()}?#{@queryParams()}"
  host: -> 'developer.trimet.org'
  refresh: -> @getData()
  getData: ->
    http.request({
      host: @host()
      path: @uri()
    }, (res) => @handleResponse res)
    .end()

  handleResponse: (res) -> 
    str = ''
    res.on 'data', (chunk) -> str += chunk
    res.on 'end', =>
      data = (JSON.parse str).resultSet
      @locations = data.location
      @arrivals = @injectLocationData data.arrival
      @emit 'ready'

  injectLocationData: (arrivals) ->
    _.map arrivals, (a) =>
      loc = @getLocationById a.locid
      a.locationDesc = loc.desc
      a.direction = loc.dir
      a

  getLocationById: (id) -> (_.where @locations, {id: id})[0]

  # No streetcar
  # TODO: This stopped worxin for some reason when the 
  #  returned data stopped having 'streetcar' bits in them
  busArrivals: -> 
    _.reject @arrivals, (o) -> o.streetCar? and o.streetCar
  streetcarArrivals: -> 
    _.filter @arrivals, (o) -> o.streetCar? and o.streetCar

  getArrivals: -> @arrivals
  getLocations: -> @locations