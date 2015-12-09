request = require('request-promise')
Const = require './atom-metaweather-const'

class API
    cst = null

    woeid = null
    location = null
    bothDays = true

    todayUrl = null
    tomorrowUrl = null
    todayData = null
    tomorrowData = null
    lastChecked = null


    constructor: (woeid, location, bothDays, todayUrl, tomorrowUrl)->
      @cst = new Const()
      @woeid = woeid
      @location = location
      @bothDays = bothDays
      @todayUrl = todayUrl
      @tomorrowUrl = tomorrowUrl

    refresh: ->
      if @timeToRefresh()
        [todayData, tomorowData] = [null, null]
        @setLocation()
        @setApiData()

    timeToRefresh: ->
      if @lastChecked?
        now = new Date()
        diff = Math.abs(now - @lastChecked) / 36e5
        diff >= 1
      else
        true

    setLocation: ->
      if not @location?
        if @woeid? then @_getLocationWoeid(@woeid) else @_getLocationUser()

    _getLocationWoeid: (woeid)->
      [self, woeid] = [@, woeid]
      request({ uri:"#{ self.cst.apiUrl }/#{ woeid }/", json: true })
        .then((body) ->
          self.woeid = body['woeid']
          self.location = body['title']
        )
        .catch((err) ->
          console.log(err)
        )

    _getLocationUser: ->
      # TODO: Implement me!
      @_getLocationWoeid('44418')

    setApiData: ->
      if not @todayData?
        @_getData(@todayUrl, "today")
      if @bothDays and not @tomorowData?
        @_getData(@tomorrowUrl, "tomorrow")

    _getData: (url, day)->
      [self, day, url] = [@, day, url]
      request({ uri:url, json: true })
        .then((body) ->
          self["#{ day }Data"] = body
          self.lastChecked = new Date()
        )
        .catch((error) ->
          console.log(error)
        )

    getWoeid: ->
      @woeid

    getLocation: ->
      @location

    getToday: ->
      @todayData

    getTomorrow: ->
      @tomorrowData

module.exports = API
