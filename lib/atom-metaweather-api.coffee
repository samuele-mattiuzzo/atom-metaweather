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

    initialize: (woeid, location, bothDays, todayUrl, tomorrowUrl)->
      @cst = new Const()
      @woeid = woeid
      @location = location
      @bothDays = bothDays
      @todayUrl = todayUrl
      @tomorrowUrl = tomorrowUrl

    refresh: ->
      if @timeToRefresh()
        [todayData, tomorowData] = [null, null]
        @setApiData()

    timeToRefresh: ->
      if @lastChecked?
        now = new Date()
        diff = Math.abs(now - @lastChecked) / 36e5
        dif > 1
      else
        true

    setLocation: ->
      if ~@location?
        if @woeid then _getLocationWoeid(@woeid) else _getLocationUser()

    _getLocationWoeid: (woeid) ->
      self = @
      request.get { uri:"#{ @cst.baseUrl }/#{ @woeid }/", json: true },
        (_, r, body) ->
          if r.statusCode == 200
            self.woeid = body['woeid']
            self.location = body['title']
          else
            console.log(r.statusMessage)

    _getLocationUser: ->
      # TODO: Implement me!
      @_getLocationWoeid(44418)

    setApiData: ->
      if ~@todayData?
          if @bothDays then [@_getData(@todayUrl, 1), @_getData(@tomorrowUrl, 2)] else [@_getData(@todayUrl, 1)]

    _getData: (url, day)->
        self = @
        key = if day == 1 then 'todayData' else 'tomorrowData'
        request.get { uri:"#{ url }", json: true },
          (_, r, body) ->
            if r.statusCode == 200
              # success
              self[key] = body
              self.lastChecked = new Date()
            else
              console.log(r.statusMessage)

    getLocation: -> @location
    getToday: -> @todayData
    getTomorrow: -> @tomorowData

module.exports = API
