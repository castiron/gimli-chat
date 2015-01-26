_ = require 'underscore'

# Just extend this, then add methods that end with "Interface" 
#  to set up your responses or behaviors (@r.respond, @r.hear, etc.)
module.exports = class AbstractInterface
  constructor: (args) ->
    @args = args
    @r = args.robot
    @_setup()

  initializers: -> k for k, v of @ when (_.isFunction v) and (k.match /Interface$/)
  _setup: -> 
    @setup()
    _.each @initializers(), (k) => @[k]()
  notImplemented: (msg) -> msg.send 'er.. someone needs to plz teach me to respond to that...:bow:'
  setup: ->
    # Override this if you need to do some setup stuff
