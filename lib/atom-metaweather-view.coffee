request = require('request')

class MetaweatherView extends HTMLElement
  url: "https://www.metaweather.com/api/location"
  locationWoeid: null
  locationName: null
  todayDate: null
  tomorrowDate: null
  cycleDates: true
  showTomorrow: false
  showTemperature: true
  showWind: false
  showHumidity: false

  initialize: (@statusBar) ->
    @classList.add('atom-metaweather', 'inline-block')
    # TODO: style it
    @content = document.createElement('div')
    @content.classList.add('atom-metaweather')
    @appendChild(@content)

    @_loadSettings()

    @activeItemSubscription = atom.workspace.onDidChangeActivePaneItem =>
      @update()

    @update()

  _loadSettings: ->
      # reads all the settings
      # TODO: implement smart logic to fetch location data from API
      @locationWoeid = atom.config.get('atom-metaweather.location')
      @locationName = atom.config.get('atom-metaweather.locationName')
      @cycleDates = atom.config.get('atom-metaweather.cycleDates')
      @showTemperature = atom.config.get('atom-metaweather.showTemperature')
      @showHumidity = atom.config.get('atom-metaweather.showHumidity')
      @showWind = atom.config.get('atom-metaweather.showWind')

      td = new Date()
      dd = td.getDate()
      mm = td.getMonth()+1
      yyyy = td.getFullYear()

      @todayDate = "#{ yyyy }/#{ mm }/#{ dd }"
      @tomorrowDate = "#{ yyyy }/#{ mm }/#{ dd+1 }"

  getLocationData: ->
    if !@locationName?
      # get from locationUrl
      locationUrl = "#{ @url }/#{ @locationWoeid }/"
      request.get { uri:locationUrl, json: true }, (_, r, body) ->
        if r.statusCode == 200
          @locationName = body['title']
        else
          console.log(r.statusMessage)
          @locationName = '-'

  getLatestWeatherInfo: (date) ->
      # creates the output string
      latest = date[0]
      result = ""
      # temperature?
      if @showTemperature
        result += " #{ parseInt(latest['the_temp']) }C"
        # glyph
        # TODO: map glyphs to weather_state_name
        glyph = latest['weather_state_name']
      # wind?
      if @showWind
        result += " #{ parseInt(latest['wind_speed']) } #{ latest['wind_direction_compass'] }"
      # humidity?
      if @showHumidity
        result += " #{ parseInt(atest['humidity']) }%"
      # indicator
      # TODO: style it as bars ||| red1, yellow2, green3 (glyph?)
      p = parseInt(latest['predictability'])
      result += " #{ p }%"

  getApiData: ->
      # selects the correct url based on date and cycle setting
      getUrl = "#{ @url }/#{ @locationWoeid }/#{ @todayDate }/"
      if @cycleDates
        if @showTomorrow
          getUrl = "#{ @url }/#{ @locationWoeid }/#{ @tomorrowDate }/"

      [resp, result] = ['-', '-']
      self = this
      request.get { uri:getUrl, json: true }, (_, r, body) ->
        resp = r.statusCode
        if resp == 200
          # success
          result = self.getLatestWeatherInfo body
        else
          # TODO: better logging report to user
          console.log(resp)
          console.log(r.statusMessage)
        self.writeApiData(resp, result)

  writeApiData: (r, data)->
      # composes the final message and writes it in the status bar
      day = ''
      if @locationName != '-'
        day = if not @showTomorrow then ' today' else ' tomorrow'
      resp = if r == 200 then '' else "(#{ r })"

      @showTomorrow = if @cycleDates then !@showTomorrow else @showTomorrow
      @content.innerHTML = "#{ @locationName }#{ day }: #{ data }#{ resp }"

  # Public: Updates the indicator.
  update: ->
    if @locationWoeid?
      @getApiData()

  # Tear down any state and detach
  destroy: ->
    @activeItemSubscription.dispose()


module.exports = document.registerElement('status-bar-metaweather',
                                          prototype: MetaweatherView.prototype,
                                          extends: 'div')
