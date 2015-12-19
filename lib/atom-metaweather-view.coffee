shell = require 'shell'

Format = require './atom-metaweather-format'
Const = require './atom-metaweather-const'
API = require './atom-metaweather-api'

class MetaweatherView extends HTMLElement
  format: null
  cst: null
  api: null

  locationWoeid: null
  locationName: null
  todayDate: null
  todayDay: null
  tomorrowDate: null
  tomorrowDay: null

  cycleDates: null
  cycleTime: null
  showTomorrow: null
  showTemperature: null
  temperatureMeasure: null
  showWeatherIcon: null
  showWind: null
  windMeasure: null
  showHumidity: null
  showPredictability: null
  updateTime: null


  initialize: (@statusBar) ->
    @_loadSettings()

    @classList.add(@cst.packageClass, 'inline-block')
    @content = document.createElement('div')
    @content.classList.add(@cst.packageClass)

    @appendChild(@content)
    @update()

  _loadSettings: ->
    @format = Format
    @cst = new Const()

    # reads all the settings
    @locationWoeid = atom.config.get(@cst.SettingsLocationWoeid)
    @locationName = atom.config.get(@cst.SettingsLocationName)
    @cycleDates = atom.config.get(@cst.SettingsCycleDates)
    @cycleTime = atom.config.get(@cst.SettingsCycleTime)
    @showTemperature = atom.config.get(@cst.SettingsShowTemperature)
    @temperatureMeasure = atom.config.get(@cst.SettingsTemperatureMeasure)
    @showHumidity = atom.config.get(@cst.SettingsShowHumidity)
    @showWind = atom.config.get(@cst.SettingsShowWind)
    @windMeasure = atom.config.get(@cst.SettingsWindMeasure)
    @showPredictability = atom.config.get(@cst.SettingsShowPredictability)
    @showWeatherIcon = atom.config.get(@cst.SettingsShowWeatherIcon)
    @updateTime = atom.config.get(@cst.SettingsUpdateTime)

    # sets up dates
    [dd, mm, yyyy, tod, tom] = @_dateSettings()
    @todayDate = "#{ yyyy }/#{ mm }/#{ dd }"
    @todayDay = tod
    @tomorrowDate = "#{ yyyy }/#{ mm }/#{ dd+1 }"
    @tomorrowDay = tom

    # finally, creates the api object
    @_createApi()

  _createApi: ->
    # creates the api object without resolving it
    updateTime = if @updateTime? then @updateTime else null
    @api = new API(
      @locationWoeid,
      @locationName,
      @cycleDates,
      updateTime,
      "#{ @cst.apiUrl }/#{ @locationWoeid }/#{ @todayDate }/",
      "#{ @cst.apiUrl }/#{ @locationWoeid }/#{ @tomorrowDate }/"
    )

  _dateSettings: ->
    td = new Date()
    dd = td.getDate()
    mm = td.getMonth()+1
    yyyy = td.getFullYear()

    tod = @cst.wdays[td.getDay()]
    tom = @cst.wdays[td.getDay()+1]
    [dd, mm, yyyy, tod, tom]

  getLocationData: ->
    @locationWoeid = @api.getWoeid()
    @locationName = @api.getLocation()

  _contentOnclick: ->
    # adds a link to metaweather site
    @content.onclick = (event, element) =>
      date = if @cycleDates and @showTomorrow then @tomorrowDate else @todayDate
      shell.openExternal("#{ @cst.baseUrl }/#{ @locationWoeid }/#{ date }/")

  _formatOutput: (data) ->
      # creates the output string
      day = if not data? then null else data[0]
      f = new @format(day, @)
      f.get()

  _writeData: ->
      data = if @cycleDates and @showTomorrow then @api.getTomorrow() else @api.getToday()
      @content.innerHTML = @_formatOutput data
      @_contentOnclick() unless not data?

      # doesn't loop unnecessarily
      mustLoop = @cycleDates or not(@api.getTomorrow()? or @api.getToday())
      if mustLoop
        # switches between today and tomorrow, if
        # every cycleTime
        @showTomorrow = @cycleDates and not @showTomorrow
        setTimeout @_writeData.bind(@), @cycleTime * @cst.SEC

  # Public: Updates the indicator.
  update: ->
    # api object will take care of refresh times
    @api.refresh()
    if not @locationWoeid?
      @getLocationData()
    # loops
    @_writeData()
    # re-updates every 30 minutes to avoid missing weather updates
    setTimeout @update.bind(@), @updateTime * 60 * @cst.SEC


module.exports = document.registerElement('status-bar-metaweather',
                                          prototype: MetaweatherView.prototype,
                                          extends: 'div')
