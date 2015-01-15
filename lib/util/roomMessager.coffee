###########
# Utility objy for messaging a room by id
###########
module.exports = class RoomMessager
  constructor: (args) ->
    @r = args.robot
    @roomId = args.roomId
  
  say: (m) -> if @roomIdIsValid() then @r.messageRoom @roomId, m
  
  roomIdIsValid: -> @roomId != ''
