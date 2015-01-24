http = require 'http'
_ = require 'underscore'
EventEmitter = require('events').EventEmitter

# DATA FETCHER
class TrimetBusDataService extends EventEmitter
  constructor: (args) ->
    @appId = args.appId
    @locIds = args.locationIds
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
      @arrivals = data.arrival
      @emit 'ready'

  getArrivals: -> @arrivals
  getLocations: -> @locations

# INTERFACE
module.exports = (r) ->
  D = new TrimetBusDataService
    appId: '838728B06B7791BD7ABA6D657'
    locationIds: ['13689', '13613', '13597']
  r.respond /bus data/i, (msg) ->
    D.once 'ready', -> 
      console.log D.getArrivals()
    D.refresh()
