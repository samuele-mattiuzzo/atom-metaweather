{CompositeDisposable} = require 'atom'

MetaweatherView = require './atom-metaweather-view'

# Handles the activation and deactivation of the package.
class Metaweather
  # Private: Default configuration.
  config:
    location:
      type: 'string'
      default: '44418'
    locationName:
      type: 'string'
      default: 'London'
    updateTime:
      type: 'string'
      default: '300'
    position:
      type: 'string'
      default: 'right'
      enum: ['left', 'right']
    cycleDates:
      type: 'boolean'
      default: true
    showTemperature:
      type: 'boolean'
      default: true
    showWind:
      type: 'boolean'
      default: false
    showHumidity:
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
    @subscriptions?.dispose()
    @destroyTile()

  # Private: Destroys the status bar indicator view and its tile.
  destroyTile: ->
    @view?.destroy()
    @view = null
    @tile?.destroy()
    @tile = null

  # Private: Creates the set of event observers.
  observeEvents: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.onDidChange 'atom-metaweather.position', =>
      @destroyTile()
      @updateTile()

  # Private: Updates the status bar indicator view and its tile.
  updateTile: ->
    priority = 100

    @view = new MetaweatherView
    @view.initialize(@statusBar)

    if atom.config.get('atom-metaweather.position') is 'right'
      @tile = @statusBar.addRightTile(item: @view, priority: priority)
    else
      @tile = @statusBar.addLeftTile(item: @view, priority: priority)

module.exports = new Metaweather
