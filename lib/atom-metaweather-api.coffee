request = require('request')
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
      if ~@location?
        if @woeid? then @_getLocationWoeid() else @_getLocationUser()

    _getLocationWoeid: ->
      self = @
      request.get { uri:"#{ self.cst.apiUrl }/#{ self.woeid }/", json: true },
        (_, r, body) ->
          if r.statusCode == 200
            self.woeid = body['woeid']
            self.location = body['title']
          else
            console.log(r.statusMessage)

    _getLocationUser: ->
      # TODO: Implement me!
      @_getLocationWoeid('44418')

    setApiData: ->
      if ~@todayData?
        @_getData(@todayUrl, 1)
      if @bothDays and ~@tomorowData?
        @_getData(@tomorrowUrl, 2)

    _getData: (url, day)->
        [self, day, url] = [@, day, url]
        request.get { uri:url, json: true },
          (_, r, body) ->
            if r.statusCode == 200
              # success
              if day == 1
                self.todayData = body
              else
                self.tomorrowData = body
              self.lastChecked = new Date()
            else
              console.log(r.statusMessage)

    getLocation: ->
      @setLocation()
      return null unless @location

    getToday: ->
      @todayData

    getTomorrow: ->
      @tomorrowData

module.exports = API
