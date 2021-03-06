{CompositeDisposable} = require 'atom'

MetaweatherView = require './atom-metaweather-view'

# Handles the activation and deactivation of the package.
class Metaweather
  # Private: Default configuration.
  config:
    location:
      type: 'integer'
      default: 44418
    locationName:
      type: 'string'
      default: 'London'
    autoLocation:
      type: 'boolean'
      default: false
    updateTime:
      type: 'integer'
      default: 30
      enum: [15, 30, 60, 120]
    position:
      type: 'string'
      default: 'right'
      enum: ['left', 'right']
    cycleDates:
      type: 'boolean'
      default: false
    cycleTime:
      type: 'integer'
      default: 30
      enum: [30, 60, 120, 300]
    showTemperature:
      type: 'boolean'
      default: true
    temperatureMeasure:
      type: 'string'
      default: 'C'
      enum: ['C', 'F']
    showWeatherIcon:
      type: 'boolean'
      default: true
    showWind:
      type: 'boolean'
      default: false
    windMeasure:
      type: 'string'
      default: 'MPH'
      enum: ['MPH', 'KPH']
    showHumidity:
      type: 'boolean'
      default: false
    showPredictability:
      type: 'boolean'
      default: false


  # Private: Metaweather view.
  view: null

  # Public: Activates the package.
  activate: ->
    @observeEvents()

  # Private: Consumes the status-bar service.
  #
  # * `statusBar` Status bar service.
  consumeStatusBar: (@statusBar) ->
    @updateTile()

  # Public: Deactivates the package.
  deactivate: ->
    @destroyTile()

  # Private: Destroys the status bar indicator view and its tile.
  destroyTile: ->
    @subscriptions?.dispose()
    @view = null
    @tile?.destroy()
    @tile = null

  refresh: ->
    @destroyTile()
    @updateTile()

  # Private: Creates the set of event observers.
  observeEvents: ->
    settingsValues = [
      "atom-metaweather.showTemperature",
      "atom-metaweather.showHumidity",
      "atom-metaweather.showWind",
      "atom-metaweather.showPredictability",
      "atom-metaweather.showWeatherIcon",
      "atom-metaweather.position",
      "atom-metaweather.autoLocation",
      "atom-metaweather.windMeasure",
      "atom-metaweather.temperatureMeasure",
    ]
    @subscriptions = new CompositeDisposable
    for index of settingsValues
      @subscriptions.add atom.config.onDidChange settingsValues[index], =>
        @destroyTile()
        @updateTile()

    @subscriptions.add atom.commands.add 'atom-workspace',
      'atom-metaweather:refresh': => @refresh()

  # Private: Updates the status bar indicator view and its tile.
  updateTile: ->
    priority = 100

    @view = new MetaweatherView
    @view.initialize(@statusBar)

    if atom.config.get('atom-metaweather.position') is 'right'
      @tile = @statusBar?.addRightTile(item: @view, priority: priority)
    else
      @tile = @statusBar?.addLeftTile(item: @view, priority: priority)

module.exports = new Metaweather
