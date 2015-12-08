class Format
  data = []


  constructor: (data, obj) ->
    @data = data
    @obj = obj

  _formatPre: ->
    # composes the final message and writes it in the status bar
    tagOpen = "<span class='location'>"
    tagClose= "</span>"
    result = ""
    if @obj.locationName?
      day = if not @obj.showTomorrow then @obj.todayDay else @obj.tomorrowDay
      loc = @obj.locationName.substring(0,3).toUpperCase()
      result = "<span class='title'>#{ loc }</span> #{ day }"
    result = if result.length then result else '-'
    "#{ tagOpen }#{ result }#{ tagClose }"

  _formatTemperature: ->
    # temperature?
    result = ""
    if @obj.showTemperature
      result = "<span class='temperature'> #{ parseInt(@data['the_temp']) }</span>"

    # glyph
    if @obj.showWeatherIcon?
      glyphClass = "state-#{ @data['weather_state_abbr'] }"
      result += " <span class='#{ glyphClass }'></span>"

    result

  _formatWind: ->
    # wind?
    result = ""
    if @obj.showWind
      cls = @data['wind_direction_compass'].toLowerCase()
      result = " <span class='dir-#{ cls }'><span class='wind'>#{ parseInt(@data['wind_speed']) }</span></span>"
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
      else if prd > 70
          prdClass = 'good'
      result = " <span class='predict-#{ prdClass }''></span>"
    result

  _formatAll: ->
    tagOpen = "<span class='stats'>"
    tagClose= "</span>"
    result = '-'
    if @data?
      temperature = @_formatTemperature()
      wind = @_formatWind()
      humidity = @_formatHumidity()
      predict = @_formatPredictability()
      result = "#{ temperature}#{ humidity }#{ wind }#{ predict }"
      result = if result.length then result else '-'
    else
      result
    "#{ tagOpen }#{ result }#{ tagClose }"

  get: ->
    pre = @_formatPre()
    out = @_formatAll()

    "#{ pre }: #{ out }"

module.exports = Format
