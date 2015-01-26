_ = require 'underscore'
F = require './messageFormatter.coffee'

module.exports = class TabularMessage

  constructor: (data, args) ->
    @args = args
    @data = data
    @transform = args.transform
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
    rows = []
    d = @_transform @data
    _.each d, (r) => @trackColWidths r
    console.log @colWidths
    _.each d, (r) => rows.push @formatRow r
    F.codeBlock rows.join "\n"

  formatRow: (r) ->
    buf = []
    _.each @cols, (col) =>
      v = if r[col]? then @normalizeWidthForCol(col, "#{r[col]}") else '--'
      buf.push v
    buf.join ' | '

  normalizeWidthForCol: (col, v) ->
    w = @colWidths[col]
    while v.length < w
      v += ' '
    v

  trackColWidths: (r) ->
    _.each @cols, (col) =>
      if r[col]? then @updateColWidth col, "#{r[col]}".length

  _transform: (obj) -> _.map obj, (o) => if _.isFunction @transform then @transform o else o

  _keys: ->
    out = []
    _.reduce @data, (
      (res, o) -> 
        _.union res, _.keys o
    ), []
