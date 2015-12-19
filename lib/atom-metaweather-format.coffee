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

  _getTemp: ->
    temp = parseInt(@data['the_temp'])
    if @obj.temperatureMeasure == 'F'
      temp = (temp * 9/5) + 32
    [parseInt(temp), @obj.temperatureMeasure]

  _formatTemperature: ->
    # temperature?
    if @obj.showTemperature
      [temperature, t_class] = @_getTemp()
      "<span class='temperature-#{ t_class }'> #{ temperature }</span>"
    else
      ""

  _formatWeatherIcon: ->
    # glyph
    if @obj.showWeatherIcon?
      glyphClass = "state-#{ @data['weather_state_abbr'] }"
      " <span class='#{ glyphClass }'></span>"
    else
      ""

  _getWind: ->
    wind_speed = parseInt(@data['wind_speed'])
    if @obj.windMeasure == 'KPH'
      wind_speed = wind_speed * 1.61
    [parseInt(wind_speed), @obj.windMeasure]

  _formatWind: ->
    # wind?
    if @obj.showWind
      [wind_speed, w_class] = @_getWind()
      cls = @data['wind_direction_compass'].toLowerCase()
      " <span class='dir-#{ cls }'><span class='wind-#{ w_class }'>#{ wind_speed }</span></span>"
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
      lastUp = @obj.api.lastChecked.toTimeString()
      result = "#{ temperature}#{ icon }#{ humidity }#{ wind }#{ predict } #{ lastUp }"
      "#{ tagOpen }#{ result }#{ tagClose }"
    else
      "#{ tagOpen }-#{ tagClose }"

  get: ->
    pre = @_formatPre()
    out = @_formatAll()

    "#{ pre }: #{ out }"

module.exports = Format
