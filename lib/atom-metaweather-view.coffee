request = require('request')
Format = require './atom-metaweather-format'

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
  format: null

  initialize: (@statusBar) ->
    @format = Format
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
      @cycleDates = atom.config.get('atom-metaweather.cycleDates')
      @showTemperature = atom.config.get('atom-metaweather.showTemperature')
      @showHumidity = atom.config.get('atom-metaweather.showHumidity')
      @showWind = atom.config.get('atom-metaweather.showWind')
      @_getLocationData()

      td = new Date()
      dd = td.getDate()
      mm = td.getMonth()+1
      yyyy = td.getFullYear()

      @todayDate = "#{ yyyy }/#{ mm }/#{ dd }"
      @tomorrowDate = "#{ yyyy }/#{ mm }/#{ dd+1 }"

  _getLocationData: ->
    loc = atom.config.get('atom-metaweather.locationName')
    if !loc?
      # get from api
      request.get { uri:"#{ @url }/#{ @locationWoeid }/", json: true },
        (_, r, body) ->
          if r.statusCode == 200
            body['title']
          else
            console.log(r.statusMessage)
            null
    @locationName = loc

  _formatOutput: (data) ->
      # creates the output string
      f = new @format(data[0], this)
      f.get()

  _getApiData: ->
      # selects the correct url based on date and cycle setting
      getDate = if @cycleDates and @showTomorrow then @tomorrowDate else @todayDate
      [resp, data, self] = ['-', '-', this]
      request.get { uri:"#{ @url }/#{ @locationWoeid }/#{ getDate }/", json: true },
        (_, r, body) ->
          if r.statusCode == 200
            # success
            data = self._formatOutput body
          else
            # TODO: better logging report to user
            console.log(r.statusMessage)
          self._writeData(data)

  _writeData: (data)->
      @showTomorrow = if @cycleDates then !@showTomorrow else @showTomorrow
      @content.innerHTML = data

  # Public: Updates the indicator.
  update: ->
    if @locationWoeid?
      @_getApiData()

  # Tear down any state and detach
  destroy: ->
    @activeItemSubscription.dispose()


module.exports = document.registerElement('status-bar-metaweather',
                                          prototype: MetaweatherView.prototype,
                                          extends: 'div')
