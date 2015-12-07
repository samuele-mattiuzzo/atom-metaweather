# Atom Metaweather
[![Version](https://badge.fury.io/gh/samuele-mattiuzzo%2Fatom-metaweather.svg)](https://badge.fury.io/gh/samuele-mattiuzzo%2Fatom-metaweather) [![Build Status](https://travis-ci.org/samuele-mattiuzzo/atom-metaweather.svg?branch=master)](https://travis-ci.org/samuele-mattiuzzo/atom-metaweather)

Atom Metaweather is a status bar plugin for [Atom](http://atom.io) editor that displays weather information for today and tomorrow
and uses [metaweather.com](https://www.metaweather.com) API data.

Status bar with all elements:

![Atom Metaweather 0.1.6 in action](https://github.com/samuele-mattiuzzo/atom-metaweather/blob/master/screenshot.png?raw=true)


## Configuration

* `location` &mdash; WOEID of the location (see [next section](#Get WOEID value from metaweather.com))
* `locationName` &mdash; Name of the location (leave blank to fetch from API)
* `showTemperature` &mdash; Shows temperature indicator [`true`, `false`]
* `showWind` &mdash; Shows winds indicator [`true`, `false`]
* `showHumidity` &mdash; Shows humidity indicator [`true`, `false`]
* `showPredictability` &mdash; Shows validity of prediction indicator [`true`, `false`]
* `position` &mdash; Control the placement of the indicator [`left`, `right`]
* `updateTime` &mdash; Control the refresh time (150s default)


### Get WOEID value from metaweather.com

The [WOEID](https://developer.yahoo.com/geo/geoplanet/guide/concepts.html) number is a location identifier used by this package to query the API service.
To get your city's number, visit https://www.metaweather.com/api/#locationsearch and follow the instructions:
- search for your city: `/api/location/search/?query=london`
- the API response will give you the WOEID number `44418`
- open atom-metaweather settings and add the WOEID number
- [optional] you can use the `title` response field to populate locationName


## Copyright

Copyright &copy; 2014-2015 [Samuele Mattiuzzo](https://samuele-mattiuzzo.github.io).
