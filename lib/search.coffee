ChromeHistoryAPI = require './chrome_history_api'

class BH.Lib.SearchHistory
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

          @worker 'searchSanitizer', options, (results) =>
            setCache = (results) =>
              chrome.storage.local.set lastSearchCache:
                results: results
                datetime: new Date().getTime()
                query: @query
                startTime: startTime
                endTime: endTime

            if startTime && endTime
              @worker 'rangeSanitizer', {
                options:
                  startTime: startTime
                  endTime: endTime
                results: results
              }, (sanitizedResults) =>
                setCache(sanitizedResults)
                callback parse(sanitizedResults)
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

parse = (visits) ->
  for visit, i in visits
    fillInVisit(visit)

fillInVisit = (visit) ->
  visit.host = getDomain(visit.url)
  visit.location = visit.url
  visit.path = visit.url.replace(visit.domain, '')
  visit.title = '(No Title)' if visit.title == ''
  visit.name = visit.title
  visit

getDomain = (url) ->
  match = url.match(/\w+:\/\/(.*?)\//)
  if match == null then null else match[0]

module.exports = Search
