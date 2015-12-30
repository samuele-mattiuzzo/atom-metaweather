Metaweather = require '../lib/atom-metaweather'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Metaweather", ->
  [weather, workspaceElement, statusBar] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    atom.workspaceView = workspaceElement.__spacePenView
    jasmine.attachToDOM(workspaceElement)
    atom.config.set('atom-metaweather.position', 'left')
    waitsForPromise -> atom.packages.activatePackage('status-bar')
    waitsForPromise -> atom.packages.activatePackage('atom-metaweather')

    runs ->
      atom.config.set('atom-metaweather.position', "right")
      atom.config.set('atom-metaweather.location', 44418)
      settings = ['showTemperature', 'showHumidity', 'showWind']
      for index in settings
        atom.config.set("atom-metaweather.#{ settings[index] }", true)
      atom.packages.emitter.emit('did-activate-all')

      weather = Metaweather.view
      weather.api.woeid = 44418
      weather.api.location = 'London'
      weather.api.lastChecked = new Date()
      weather.api.todayData = [{
        "weather_state_name": "Heavy Cloud",
        "weather_state_abbr": "hc",
        "wind_direction_compass": "SW",
        "the_temp": 12.265000000000001,
        "wind_speed": 24.026236683333334,
        "humidity": 72,
        "predictability": 71}]
      weather.api.tomorrowData = weather.api.todayData

  describe '::initialize', ->
    it 'displays in the status bar', ->
      expect(weather).toBeDefined()
      expect(weather.classList.contains('atom-metaweather')).toBeTruthy()

    it 'is correctly positioned', ->
      expect(weather.parentNode.classList.contains('status-bar-right')).toBeTruthy()

    it 'contains the data', ->
      expect((weather.getElementsByClassName 'stats')[0]).toBeTruthy()

  describe '::deactivate', ->
    it 'removes the weather view', ->
      expect(weather).toExist()
      atom.packages.deactivatePackage('atom-metaweather')
      expect(Metaweather.view).toBeNull()

    it 'can be executed twice', ->
      atom.packages.deactivatePackage('atom-metaweather')
      atom.packages.deactivatePackage('atom-metaweather')

  describe 'when the configuration changes', ->
    it 'moves the weather', ->
      atom.config.set('atom-metaweather.position', 'right')
      expect(weather.parentNode.classList.contains('status-bar-right')).toBeTruthy()

    it 'hides the relative item', ->
      settings = ['showTemperature', 'showHumidity', 'showWind']
      classes = ['temperature-C', 'humidity', 'wind-KPH']

      for index in settings
        atom.config.set("atom-metaweather.#{ settings[index] }", false)
        expect((weather.getElementsByClassName classes[index])[0]).toBe(undefined)
