Chrome Historian
======================

A better wrapper for the [Chrome History API](https://developer.chrome.com/extensions/history) that also merges in downloads from the [Chrome Download API](https://developer.chrome.com/extensions/downloads).

This is the secret sauce behind [Better History](https://chrome.google.com/webstore/detail/better-history/obciceimmggglbmelaidpjlmodcebijb)

[![NPM version](https://badge.fury.io/js/chrome-historian.svg)](http://badge.fury.io/js/chrome-historian)
[![Bower version](https://badge.fury.io/bo/chrome-historian.svg)](http://badge.fury.io/bo/chrome-historian)
[![Build Status](https://travis-ci.org/better-history/chrome-historian.svg?branch=master)](https://travis-ci.org/better-history/chrome-historian)


Managing a day's history
---------------------

The Chrome History API has been known to return visits that do not fall between the requested dates and visits that are out of order. Querying a day's history via Chrome Historian will guarantee all returned visits occured on the requested day and are in descending order.

```coffee
  dayHistorian = new Historian.Day(new Date())

  dayHistorian.fetch (visits) ->
    if visits
      console.log(visits)
    else
      console.log('Feature is not supported in your browser version')

  dayHistorian.destroy()

  dayHistorian.destroyHour(22)
```

Searching history
---------------------

The Chrome History API has been known to return very generous matches (not in a good way). Searching via Chrome Historian will guarantee all returned visits have a title or url that partially matches the query.

```coffee
  searchHistorian = new Historian.Search('gmail')

  searchHistorian.fetch maxResults: 10000, (visits) ->
    console.log(visits)

  # The search historian caches the last search via chrome's local storage api
  searchHistorian.expireCache()

  # It's important to use these to delete because they both update the
  # previous search cache to reflect the removals
  searchHistorian.deleteUrl()
  searchHistorian.destroy()
```

Device Sessions
---------------------

Easily interaction with Device browser sessions that are logged into the same Google account
```coffee
  historian = new Historian.Devices()

  historian.fetch (devices) ->
    if devices
      console.log(devices) # ['Nexus 5', 'Desktop', 'Nexus 7']
    else
      console.log('Feature is not supported in your browser version')

    # ...a bit later

    if devices
      historian.fetchSessions(devices[0], (sessions) ->
        console.log(sessions)
        # [{
        #   sessionId: 'session_sync43908482591051-257446.1'
        #   sites: []
        # }]
```


Simple deleting
----------------------

```coffee
  Historian.deleteUrl('http://google.com')

  Historian.deleteDownload('http://google.com/file.zip')

  Historian.deleteRange
    startTime: new Date('Aug 20, 2014')
    endTime: new Date('Aug 30, 2014')

  Historian.deleteAll()
```
