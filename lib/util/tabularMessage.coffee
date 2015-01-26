_ = require 'underscore'
F = require './messageFormatter.coffee'

module.exports = class TabularMessage

  constructor: (data, args) ->
    @args = args || {}
    @data = data
    @header = @args.header
    @transform = @args.transform
    @initCols()
    @initColWidths()

  initCols: ->
    @cols = if @args.cols? then (_.intersection @args.cols, @_keys()) else @_keys()

  initColWidths: ->
    @colWidths = []
    _.each @cols, (c) => 
      @colWidths[c] = c.length

  updateColWidth: (c, v) ->
    if v? then @colWidths[c] = Math.max v, @colWidths[c]

  formatted: ->
    d = @_transform @data
    _.each d, (r) => @trackColWidths r
    rows = @headerRow()
    _.each d, (r) => rows.push @formatRow r
    F.codeBlock rows.join "\n"

  headerRow: ->
    if @header
      h = @formatHeaderRow()
      div = @beefRight '', h.length, '-' 
      [h, div]
    else
      []

  formatHeaderRow: ->
    buf = []
    _.each @cols, (col) =>
      buf.push @normalizeWidthForCol col, col
    buf.join ' | '

  formatRow: (r) ->
    buf = []
    _.each @cols, (col) =>
      v = if r[col]? then @normalizeWidthForCol(col, r[col]) else '--'
      buf.push v
    buf.join ' | '

  normalizeWidthForCol: (col, v) ->
    v = "#{v}"
    w = @colWidths[col]
    @beefRight v, w

  beefRight: (str, l, char = ' ') ->
    while str.length < l
      str += char 
    str

  trackColWidths: (r) ->
    _.each @cols, (col) =>
      if r[col]? then @updateColWidth col, "#{r[col]}".length

  # TODO: get this out of here - violates single purpose
  _transform: (obj) -> _.map obj, (o) => if _.isFunction @transform then @transform o else o

  _keys: ->
    out = []
    _.reduce @data, (
      (res, o) -> 
        _.union res, _.keys o
    ), []
