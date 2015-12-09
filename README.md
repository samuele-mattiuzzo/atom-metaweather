# Atom Metaweather
[![Version](https://badge.fury.io/gh/samuele-mattiuzzo%2Fatom-metaweather.svg)](https://badge.fury.io/gh/samuele-mattiuzzo%2Fatom-metaweather) [![Build Status](https://travis-ci.org/samuele-mattiuzzo/atom-metaweather.svg?branch=master)](https://travis-ci.org/samuele-mattiuzzo/atom-metaweather) [![Requirements Status](https://requires.io/github/samuele-mattiuzzo/atom-metaweather/requirements.svg?branch=master)](https://requires.io/github/samuele-mattiuzzo/atom-metaweather/requirements/?branch=master)


Atom Metaweather is a status bar plugin for [Atom](http://atom.io) editor that displays weather information for today and tomorrow
and uses [metaweather.com](https://www.metaweather.com) API data.

Status bar with all elements:

![Atom Metaweather 0.3.0 in action](https://github.com/samuele-mattiuzzo/atom-metaweather/blob/master/screenshot.png?raw=true)


## Configuration

* `location` &mdash; WOEID of the location (see [next section](#get-woeid-value-from-metaweathercom)). (TBD: Leave blank to automatically fetch from the user's current location)
* `locationName` &mdash; Name of the location. Leave blank to automatically fetch from API
* `showTemperature` &mdash; Shows the temperature meter [`true`, `false`]
* `showWeatherIcon` &mdash; Shows the weather state icon [`true`, `false`]
* `showWind` &mdash; Shows the wind speed meter [`true`, `false`]
* `showHumidity` &mdash; Shows the humidity meter [`true`, `false`]
* `showPredictability` &mdash; Shows an indicator for the validity of a prediction (red=bad, yellow=average, green=good)[`true`, `false`]
* `position` &mdash; Control the placement of the meters [`left`, `right`]
* `cycleDates` &mdash; Allow cycling through today/tomorrow (default `true`)
* `cycleTime` &mdash; Control the refresh time in seconds between today and tomorrow dates cycle [30, 60, 120, 300]
* `updateTime` &mdash; Control the API refresh time in minutes [15, 30, 60, 120]


### Get WOEID value from metaweather

The [WOEID](https://developer.yahoo.com/geo/geoplanet/guide/concepts.html) number is a location identifier used by this package to query the API service.
To get your city's number, visit https://www.metaweather.com/api/#locationsearch and follow the instructions:
- search for your city: `/api/location/search/?query=london`
- the API response will give you the WOEID number `44418`
- open atom-metaweather settings and add the WOEID number
- [optional] you can use the `title` response field to populate locationName


## Credits

All weather data and icons are taken from [metaweather.com](https://www.metaweather.com)


## Copyright

Copyright &copy; 2014-2015 [Samuele Mattiuzzo](https://samuele-mattiuzzo.github.io).
