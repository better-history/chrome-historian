Chrome Historian
======================

A better wrapper for the [Chrome History API](https://developer.chrome.com/extensions/history)

a.k.a. the secret sauce behind [Better History](https://chrome.google.com/webstore/detail/better-history/obciceimmggglbmelaidpjlmodcebijb)

[![NPM version](https://badge.fury.io/js/chrome-historian.svg)](http://badge.fury.io/js/chrome-historian)


Managing a day's history
---------------------

The Chrome History API has been known to return visits that do not fall between the requested dates and visits that are out of order. Querying a day's history via Chrome Historian will guarantee all returned visits occured on the requested day and are in descending order.

```coffee
  dayHistorian = new Historian.Day(new Date())

  dayHistorian.fetch (visits) ->
    console.log(visits)

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

Simple deleting
----------------------

```coffee
  Historian.deleteUrl('http://google.com')

  Historian.deleteRange
    startTime: new Date('Aug 20, 2014')
    endTime: new Date('Aug 30, 2014')

  Historian.deleteAll()
```
