request = require 'request-promise'
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

    # Data fetch methods
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
        if @woeid?
          @_getLocationWoeid(@woeid).bind(@)
        else
          @_getLocationUser().bind(@)

    _getLocationWoeid: (woeid)->
      request({ uri:"#{ self.cst.apiUrl }/#{ woeid }/", json: true })
      .then(( body)=>
        [@woeid, @location] = [body['woeid'], body['title']]
      )
      .catch((err) => console.log('[ERROR] GET location:  #{ error }') )

    _getLocationUser: ->
      # TODO: Implement me!
      @_getLocationWoeid('44418')

    setApiData: ->
      if not @todayData?
        @_getData(@todayUrl, "today").bind(@)
      if @bothDays and not @tomorowData?
        @_getData(@tomorrowUrl, "tomorrow").bind(@)

    _getData: (url, day) ->
      request({uri:url, json:true})
      .then((body) =>
        @["#{ day }Data"] = body
        @lastChecked = new Date()
      )
      .catch((err) => console.log('[ERROR] GET #{ url }:  #{ error }') )

    # Getters
    getWoeid: ->
      @woeid

    getLocation: ->
      @location

    getToday: ->
      @todayData

    getTomorrow: ->
      @tomorrowData

module.exports = API
