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
    updateTime = null


    constructor: (woeid, location, bothDays, updateTime, todayUrl, tomorrowUrl)->
      @cst = new Const()
      @woeid = woeid
      @location = location
      @bothDays = bothDays
      @todayUrl = todayUrl
      @tomorrowUrl = tomorrowUrl
      @updateTime = updateTime

    # Data fetch methods
    refresh: ->
      if @timeToRefresh()
        [todayData, tomorowData] = [null, null]
        @setLocation()
        @setApiData()

    timeToRefresh: ->
      if @lastChecked?
        now = new Date()
        # diff in minutes
        diff = Math.abs(now.getTime() - @lastChecked.getTime()) / (60 * @cst.SEC)
        diff >= @updateTime
      else
        true

    setLocation: ->
      # explicit so we're sure to not miss a case
      # default means both are already set
      if atom.config.get(@cst.SettingsAutoLocation) or not @woeid?
        @_getLocationUser()
      else
        if @woeid? and not @location?
          @_getLocationWoeid(@woeid)

    _getLocationWoeid: (woeid)->
      request({ uri:"#{ @cst.apiUrl }/#{ woeid }/", json: true })
      .then( (body)=>
        [@woeid, @location] = [body['woeid'], body['title']]
      )
      .catch( (err) => console.log("[ERROR] GET location:  #{ err }") )

    _getLocationUser: ->
      geoloc = window.navigator.geolocation
      if geoloc
        geoloc.getCurrentPosition (pos)=>
          latlong = "#{ pos.coords.latitude },#{ pos.coords.longitude }"
          request({ uri:"#{ @cst.apiUrl }/search/?lattlong=#{ latlong }", json: true })
          .then( (body)=>
            # gets the closest one
            [@woeid, @location] = [body[0]['woeid'], body[0]['title']]
          )
          .catch( (err) =>
            console.log("[ERROR] GET auto location:  #{ err }")
            @_getLocationWoeid('44418')
          )
      else
        # defaults to london
        @_getLocationWoeid('44418')

    setApiData: ->
      if not @todayData?
        @_getData(@todayUrl, "today").bind(@)
      if @bothDays and not @tomorowData?
        @_getData(@tomorrowUrl, "tomorrow").bind(@)

    _getData: (url, day) ->
      request({uri:url, json:true})
      .then( (body) =>
        @["#{ day }Data"] = body
        @lastChecked = new Date()
      )
      .catch( (err) => console.log("[ERROR] GET #{ url }:  #{ err }") )

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
