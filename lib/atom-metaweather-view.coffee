shell = require('shell')

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

  cycleDates: true
  showTomorrow: false
  showTemperature: true
  showWeatherIcon: true
  showWind: false
  showHumidity: false
  showPredictability: false


  initialize: (@statusBar) ->
    @_loadSettings()

    #if @api.timeToRefresh
    #  @api.refresh()

    @classList.add(@cst.packageClass, 'inline-block')
    @content = document.createElement('div')
    @content.classList.add(@cst.packageClass)

    @appendChild(@content)

    @activeItemSubscription = atom.workspace.onDidChangeActivePaneItem =>
      @update()

    @update()

  _loadSettings: ->
    @format = Format
    @cst = new Const()

    # reads all the settings
    @locationWoeid = atom.config.get(@cst.SettingsLocationWoeid)
    @locationName = atom.config.get(@cst.SettingsLocationName)
    @cycleDates = atom.config.get(@cst.SettingsCycleDates)
    @showTemperature = atom.config.get(@cst.SettingsShowTemperature)
    @showHumidity = atom.config.get(@cst.SettingsShowHumidity)
    @showWind = atom.config.get(@cst.SettingsShowWind)
    @showPredictability = atom.config.get(@cst.SettingsShowPredictability)
    @showWeatherIcon = atom.config.get(@cst.SettingsShowWeatherIcon)
    @updateTime = atom.config.get(@cst.SettingsUpdateTime)


    [dd, mm, yyyy, tod, tom] = @_dateSettings()

    @todayDate = "#{ yyyy }/#{ mm }/#{ dd }"
    @todayDay = tod
    @tomorrowDate = "#{ yyyy }/#{ mm }/#{ dd+1 }"
    @tomorrowDay = tom

    @api = new API(
      @locationWoeid,
      @locationName,
      @cycleDates
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

  _getLocationData: ->
    @api.getLocation()

  _contentOnclick: ->
    @content.onclick = (event, element) =>
      date = if @cycleDates and @showTomorrow then @tomorrowDate else @todayDate
      shell.openExternal("#{ @cst.baseUrl }/#{ @locationWoeid }/#{ date }/")

  _formatOutput: (data) ->
      # creates the output string
      day = if ~data? then null else data[0]
      f = new @format(day, @)
      f.get()

  _writeData: ->
      data = if @cycleDates and @showTomorrow then @api.getTomorrow() else @api.getToday()
      @content.innerHTML = @_formatOutput(data)
      @showTomorrow = @cycleDates and not @showTomorrow

  # Public: Updates the indicator.
  update: ->
    #if ~@api? or @api.timeToRefresh()
    #  if ~@api?
    #    @api = new API(
    #      @locationWoeid,
    #      @locationName,
    #      @cycleDates
    #      "#{ @cst.apiUrl }/#{ @locationWoeid }/#{ @todayDate }/",
    #      "#{ @cst.apiUrl }/#{ @locationWoeid }/#{ @tomorrowDate }/"
    #    )
    #  @api.refresh()
    if @locationWoeid?
      @_writeData()
      @_contentOnclick()
    setTimeout @update, @updateTime * 1000

  # Tear down any state and detach
  destroy: ->
    @activeItemSubscription.dispose()


module.exports = document.registerElement('status-bar-metaweather',
                                          prototype: MetaweatherView.prototype,
                                          extends: 'div')
