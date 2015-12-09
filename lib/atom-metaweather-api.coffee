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
        if @woeid? then @_getLocationWoeid(@woeid).bind(@) else @_getLocationUser()

    _getLocationWoeid: (woeid)->
      request({ uri:"#{ self.cst.apiUrl }/#{ woeid }/", json: true })
        .then((body) ->
          @woeid = body['woeid']
          @location = body['title']
        ).catch((err) ->
          console.log(err)
        )

    _getLocationUser: ->
      # TODO: Implement me!
      @_getLocationWoeid('44418')

    setApiData: ->
      if not @todayData?
        @_getData(@todayUrl, "today").bind(@)
      if @bothDays and not @tomorowData?
        @_getData(@tomorrowUrl, "tomorrow").bind(@)

    _getData: (url, day)->
      request({uri:url, json:true})
      .then((body) ->
          @["#{ day }Data"] = body
          @lastChecked = new Date()
      ).catch((error) ->
          console.log('get data error ' + error)
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
