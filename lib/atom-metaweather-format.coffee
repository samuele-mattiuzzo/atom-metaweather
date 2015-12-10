class Format
  data: null


  constructor: (data, obj) ->
    @data = data
    @obj = obj

  _formatPre: ->
    # composes the final message and writes it in the status bar
    [tagOpen, tagClose] = ["<span class='location'>", "</span>"]
    if @obj.locationName?
      day = if not @obj.showTomorrow then @obj.todayDay else @obj.tomorrowDay
      loc = @obj.locationName.substring(0,3).toUpperCase()
      "#{ tagOpen }<span class='title'>#{ loc }</span> #{ day }#{ tagClose }"
    else
      "#{ tagOpen }-#{ tagClose }"

  _formatTemperature: ->
    # temperature?
    if @obj.showTemperature
      "<span class='temperature'> #{ parseInt(@data['the_temp']) }</span>"
    else
      ""

  _formatWeatherIcon: ->
    # glyph
    if @obj.showWeatherIcon?
      glyphClass = "state-#{ @data['weather_state_abbr'] }"
      " <span class='#{ glyphClass }'></span>"
    else
      ""

  _formatWind: ->
    # wind?
    if @obj.showWind
      cls = @data['wind_direction_compass'].toLowerCase()
      " <span class='dir-#{ cls }'><span class='wind'>#{ parseInt(@data['wind_speed']) }</span></span>"
    else
      ""

  _formatHumidity: ->
    # humidity?
    if @obj.showHumidity
      "<span class='humidity'> #{ parseInt(@data['humidity']) }</span>"
    else
      ""

  _formatPredictability: ->
    # indicator
    if @obj.showPredictability
      prdClass = 'avg'
      prd = parseInt(@data['predictability'])
      if prd <= 33
          prdClass = 'bad'
      else if prd > 70
          prdClass = 'good'
      " <span class='predict-#{ prdClass }''></span>"
    else
      ""

  _formatAll: ->
    [tagOpen, tagClose] = ["<span class='stats'>", "</span>"]
    if @data?
      temperature = @_formatTemperature()
      icon = @_formatWeatherIcon()
      wind = @_formatWind()
      humidity = @_formatHumidity()
      predict = @_formatPredictability()
      result = "#{ temperature}#{ icon }#{ humidity }#{ wind }#{ predict }"
      "#{ tagOpen }#{ result }#{ tagClose }"
    else
      "#{ tagOpen }-#{ tagClose }"

  get: ->
    pre = @_formatPre()
    out = @_formatAll()

    "#{ pre }: #{ out }"

module.exports = Format
