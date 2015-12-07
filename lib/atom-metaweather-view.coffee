request = require('request')
shell = require('shell')

Format = require './atom-metaweather-format'
Const = require './atom-metaweather-const'

class MetaweatherView extends HTMLElement
  baseUrl: null
  apiUrl: null
  locationWoeid: null
  locationName: null
  todayDate: null
  todayDay: null
  tomorrowDate: null
  tomorrowDay: null
  cycleDates: true
  showTomorrow: false
  showTemperature: true
  showWeatherIcon: true
  showWind: false
  showHumidity: false
  showPredictability: false
  format: null

  initialize: (@statusBar) ->
    @format = Format
    @const = new Const()
    @baseUrl = @const.baseUrl
    @apiUrl = @const.apiUrl
    @_loadSettings()

    @classList.add(@const.packageClass, 'inline-block')
    @content = document.createElement('div')
    @content.classList.add(@const.packageClass)

    @appendChild(@content)

    @activeItemSubscription = atom.workspace.onDidChangeActivePaneItem =>
      @update()

    @update()

  _contentOnclick: ->
    @content.onclick = (event, element) =>
      date = if @cycleDates and @showTomorrow then @tomorrowDate else @todayDate
      shell.openExternal("#{ @baseUrl }/#{ @locationWoeid }/#{ date }/")

  _loadSettings: ->
    # reads all the settings
    @locationWoeid = atom.config.get(@const.SettingsLocationWoeid)
    @cycleDates = atom.config.get(@const.SettingsCycleDates)
    @showTemperature = atom.config.get(@const.SettingsShowTemperature)
    @showHumidity = atom.config.get(@const.SettingsShowHumidity)
    @showWind = atom.config.get(@const.SettingsShowWind)
    @showPredictability = atom.config.get(@const.SettingsShowPredictability)
    @showWeatherIcon = atom.config.get(@const.SettingsShowWeatherIcon)
    @_getLocationData()

    [dd, mm, yyyy, tod, tom] = @_dateSettings()

    @todayDate = "#{ yyyy }/#{ mm }/#{ dd }"
    @todayDay = tod
    @tomorrowDate = "#{ yyyy }/#{ mm }/#{ dd+1 }"
    @tomorrowDay = tom

  _dateSettings: ->
    td = new Date()
    dd = td.getDate()
    mm = td.getMonth()+1
    yyyy = td.getFullYear()

    tod = @const.wdays[td.getDay()]
    tom = @const.wdays[td.getDay()+1]
    [dd, mm, yyyy, tod, tom]

  _getLocationData: ->
    loc = atom.config.get(@const.SettingsLocationName)
    loc = if loc == '' then null else loc
    self = @
    if !loc?
      # get from api
      request.get { uri:"#{ @apiUrl }/#{ @locationWoeid }/", json: true },
        (_, r, body) ->
          if r.statusCode == 200
            self.locationName = body['title']
          else
            console.log(r.statusMessage)
    else
      @locationName = loc

  _formatOutput: (data) ->
      # creates the output string
      f = new @format(data[0], this)
      f.get()

  _getApiData: ->
      # selects the correct url based on date and cycle setting
      getDate = if @cycleDates and @showTomorrow then @tomorrowDate else @todayDate
      [data, self] = ['-', @]
      request.get { uri:"#{ @apiUrl }/#{ @locationWoeid }/#{ getDate }/", json: true },
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
      @_contentOnclick()

  # Tear down any state and detach
  destroy: ->
    @activeItemSubscription.dispose()


module.exports = document.registerElement('status-bar-metaweather',
                                          prototype: MetaweatherView.prototype,
                                          extends: 'div')
