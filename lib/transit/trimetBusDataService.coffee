http = require 'http'
_ = require 'underscore'
EventEmitter = require('events').EventEmitter

# DATA FETCHER
module.exports = class TrimetBusDataService extends EventEmitter
  constructor: (args) ->
    @appId = args.appId
    @locIds = args.defaultLocationIds
    @getData()

  path: -> '/ws/v2/arrivals'
  queryParams: -> "appID=#{@appId}&json=true&locIDs=#{@locIds}&showPosition=true"
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
      a.locationDesc = @getLocationDescFor a.locid
      a

  getLocationDescFor: (locid) -> (_.where @locations, {id: locid})[0].desc


  # No streetcar
  busArrivals: -> _.reject @arrivals, (o) -> o.streetCar? and o.streetCar
  streetcarArrivals: -> _.filter @arrivals, (o) -> o.streetCar? and o.streetCar

  getArrivals: -> @arrivals
  getLocations: -> @locations