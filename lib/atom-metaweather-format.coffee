class Format
  data = []

  constructor: (data, obj) ->
    @data = data
    @obj = obj

  _formatPre: ->
    # composes the final message and writes it in the status bar
    result = ""
    if @obj.locationName?
      day = if not @obj.showTomorrow then ' tod' else ' tom'
      result = "#{ @obj.locationName }#{ day }"
    result

  _formatTemperature: ->
    # temperature?
    result = ""
    if @obj.showTemperature
      result = " #{ parseInt(@data['the_temp']) }C"
      # glyph
      # TODO: map glyphs to weather_state_name
      glyph = @data['weather_state_name']
    result

  _formatWind: ->
    # wind?
    result = ""
    if @obj.showWind
      result = " #{ parseInt(@data['wind_speed']) } #{ @data['wind_direction_compass'] }"
    result

  _formatHumidity: ->
    # humidity?
    result = ""
    if @obj.showHumidity
      result = " #{ parseInt(@data['humidity']) }%"
    result

  _formatPredictability: ->
    # indicator
    # TODO: style it as bars ||| red1, yellow2, green3 (glyph?)
    result = ""
    if @obj.showPredictability
      result = " #{ parseInt(@data['predictability']) }%"
    result

  get: ->
    pre = @_formatPre()
    pre = if pre.length then pre else '-'

    temperature = @_formatTemperature()
    wind = @_formatWind()
    humidity = @_formatHumidity()
    predict = @_formatPredictability()
    out = "#{ temperature}#{ humidity }#{ wind }#{ predict }"
    out = if out.length then out else '-'

    "#{ pre }: #{ out }"

module.exports = Format
