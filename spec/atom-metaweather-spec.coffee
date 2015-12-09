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
    waitsForPromise -> atom.packages.activatePackage('language-gfm')

    runs ->
      atom.config.set('atom-metaweather.position', "right")
      atom.config.set('atom-metaweather.location', 44418)
      atom.packages.emitter.emit('did-activate-all')

      weather = Metaweather.view

  describe '::initialize', ->
    it 'displays in the status bar', ->
      expect(weather).toBeDefined()
      expect(weather.classList.contains('atom-metaweather')).toBeTruthy()

    it 'is correctly positioned', ->
      expect(weather.parentNode.classList.contains('status-bar-right')).toBeTruthy()

  describe '::deactivate', ->
    it 'removes the weather view', ->
      weather = Metaweather.view
      expect(weather).toExist()

      atom.packages.deactivatePackage('atom-metaweather')

      expect(Metaweather.view).toBeNull()

    it 'can be executed twice', ->
      atom.packages.deactivatePackage('atom-metaweather')
      atom.packages.deactivatePackage('atom-metaweather')

  describe 'when the configuration changes', ->
    it 'moves the weather', ->
      atom.config.set('atom-metaweather.position', 'right')
      weather = Metaweather.view
      expect(weather.parentNode.classList.contains('status-bar-right')).toBeTruthy()
