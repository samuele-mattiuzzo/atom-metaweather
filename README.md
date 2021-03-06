# Atom Metaweather
[![Version](https://badge.fury.io/gh/samuele-mattiuzzo%2Fatom-metaweather.svg)](https://badge.fury.io/gh/samuele-mattiuzzo%2Fatom-metaweather) [![Build Status](https://travis-ci.org/samuele-mattiuzzo/atom-metaweather.svg?branch=master)](https://travis-ci.org/samuele-mattiuzzo/atom-metaweather) [![Requirements Status](https://requires.io/github/samuele-mattiuzzo/atom-metaweather/requirements.svg?branch=master)](https://requires.io/github/samuele-mattiuzzo/atom-metaweather/requirements/?branch=master)


Atom Metaweather is a status bar plugin for [Atom](http://atom.io) editor that displays weather information for today and tomorrow
and uses [metaweather.com](https://www.metaweather.com) API data.

Status bar with all elements:

![Atom Metaweather 0.7.0 in action](https://github.com/samuele-mattiuzzo/atom-metaweather/blob/master/screenshot.png?raw=true)


### Keymaps

* `ctrl-alt-w` refreshes the weather API


### Configuration

* `location `<sup>[\*](#settingsrestart)</sup> &mdash; WOEID of the location ( [?](#get-woeid-value-from-metaweathercom))
* `locationName `<sup>[\*](#settingsrestart)</sup> &mdash; Name of the location. Leave blank to automatically fetch from API (requires `location` to be set)
* `autoLocation` &mdash; Switches auto location fetching on/off [`true`, `false`] \(overwrites `location` and `locationName`\)
* `showTemperature` &mdash; Shows the temperature meter [`true`, `false`]
* `temperatureMeasure` &mdash; Selects between Celsius or Farenheit [`C`, `F`]
* `showWeatherIcon` &mdash; Shows the weather state icon [`true`, `false`]
* `showWind` &mdash; Shows the wind speed meter [`true`, `false`]
* `windMeasure` &mdash; Selects between Kilometers or Miles per hour [`kph`, `mph`]
* `showHumidity` &mdash; Shows the humidity meter [`true`, `false`]
* `showPredictability` &mdash; Shows an indicator for the validity of a prediction _(red=bad, yellow=average, green=good)_ [`true`, `false`]
* `position` &mdash; Control the placement of the meters [`left`, `right`]
* `cycleDates `<sup>[\*](#settingsrestart)</sup> &mdash; Allow cycling through today/tomorrow [`true`, `false`]
* `cycleTime `<sup>[\*](#settingsrestart)</sup> &mdash; Control the refresh time in seconds between today and tomorrow dates cycle [`30`, `60`, `120`, `300`]
* `updateTime `<sup>[\*](#settingsrestart)</sup> &mdash; Control the API refresh time in minutes [`15`, `30`, `60`, `120`]

Changing settings will take `updateTime` seconds

<sup>
<a name="settingsrestart">\*</a> _Changing this setting requires restart_

</sup>


##### Get WOEID value from metaweather

The [WOEID](https://developer.yahoo.com/geo/geoplanet/guide/concepts.html) number is a location identifier used by this package to query the API service.
To get your city's number, visit https://www.metaweather.com/api/#locationsearch and follow the instructions:
- search for your city: `/api/location/search/?query=london`
- the API response will give you the WOEID number `44418`
- open atom-metaweather settings and add the WOEID number
- [optional] you can use the `title` response field to populate locationName


### Credits

All weather data and icons are taken from [metaweather.com](https://www.metaweather.com)


### Copyright

Copyright &copy; 2014-2015 [Samuele Mattiuzzo](https://samuele-mattiuzzo.github.io).


___
<sup>

[_License_](https://github.com/samuele-mattiuzzo/atom-metaweather/blob/master/LICENSE.md)

[_Changelog_](https://github.com/samuele-mattiuzzo/atom-metaweather/blob/master/CHANGELOG.md)

[_Roadmap_](https://github.com/samuele-mattiuzzo/atom-metaweather/blob/master/ROADMAP.md)
</sup>
