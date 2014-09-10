ChromeHistoryAPI = require './chrome_history_api.coffee'
Processor = require './processor.coffee'

class Search
  constructor: (@query) ->
    @history = new ChromeHistoryAPI()

  fetch: (options, callback = ->) ->
    defaultOptions =
      text: ''
      startTime: 0
      maxResults: 5000

    options = _.extend defaultOptions, options
    {startTime, endTime} = options

    startAtResult = options.startAtResult
    delete options.startAtResult

    chrome.storage.local.get 'lastSearchCache', (data) =>
      cache = data.lastSearchCache
      if cache?.query == @query && cache?.startTime == startTime && cache?.endTime == endTime && !startAtResult
        callback cache.results, new Date(cache.datetime)
      else
        @history.query options, (history) =>
          options =
            options: {text: @query}
            results: history

          new Processor 'search_sanitizer.js', options, (results) =>
            new Processor 'groomer.js', results: results, (results) =>
              setCache = (results) =>
                chrome.storage.local.set lastSearchCache:
                  results: results
                  datetime: new Date().getTime()
                  query: @query
                  startTime: startTime
                  endTime: endTime

            if startTime && endTime
              new Processor 'range_sanitizer.js', {
                options:
                  startTime: startTime
                  endTime: endTime
                results: results
              }, (sanitizedResults) =>
                new Processor 'groomer.js', results: sanitizedResults, (results) =>
                  setCache(results)
                  callback parse(results)
            else
              setCache(results)
              callback parse(results)

  expireCache: ->
    chrome.storage.local.remove 'lastSearchCache'

  deleteUrl: (url, callback) ->
    @history.deleteUrl url, ->
      callback()

    chrome.storage.local.get 'lastSearchCache', (data) =>
      results = data.lastSearchCache.results
      data.lastSearchCache.results = _.reject results, (visit) ->
        visit.url == url
      chrome.storage.local.set data

  destroy: (options = {}, callback = ->) ->
    @fetch options, (history) =>
      for visit, i in history
        @history.deleteUrl visit.url, =>
          if i == history.length
            @expireCache()
            callback()

module.exports = Search
