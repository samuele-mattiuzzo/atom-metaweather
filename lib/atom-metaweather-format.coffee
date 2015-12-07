class Format
  data = []

  constructor: (data, obj) ->
    @data = data
    @obj = obj

  _formatPre: ->
    # composes the final message and writes it in the status bar
    result = ""
    if @obj.locationName?
      day = if not @obj.showTomorrow then @obj.todayDay else @obj.tomorrowDay
      loc = @obj.locationName.substring(0,3).toUpperCase()
      result = "<span class='location'>#{ loc }</span> #{ day }"
    result

  _formatTemperature: ->
    # temperature?
    result = ""
    if @obj.showTemperature
      result = "<span class='temperature'> #{ parseInt(@data['the_temp']) }</span>"
      # glyph
      # TODO: map glyphs to weather_state_name
      glyph = @data['weather_state_name']
      result += "<span class='snow'></span>"
    result

  _formatWind: ->
    # wind?
    result = ""
    if @obj.showWind
      cls = @data['wind_direction_compass'].toLowerCase()
      result = " <span class='#{ cls }'>#{ parseInt(@data['wind_speed']) }</span>"
    result

  _formatHumidity: ->
    # humidity?
    result = ""
    if @obj.showHumidity
      result = "<span class='humidity'> #{ parseInt(@data['humidity']) }</span>"
    result

  _formatPredictability: ->
    # indicator
    result = ""
    if @obj.showPredictability
      prdClass = 'avg'
      prd = parseInt(@data['predictability'])
      if prd <= 33
          prdClass = 'bad'
      else if prd > 66
          prdClass = 'good'
      result = " <span class='predict-#{ prdClass }''></span>"
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
