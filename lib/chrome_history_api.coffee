class ChromeHistoryAPI
  constructor: (@chromeAPI = chrome) ->

  sessions: (callback = ->) ->
    if @chromeAPI.sessions?.getDevices?
      @chromeAPI.sessions.getDevices (devices) ->
        callback(devices)
    else
      callback(false)

  query: (options, callback = ->) ->
    calls = 0
    results = []

    wrappedCallback = (visits) =>
      calls += 1
      results = results.concat(visits)
      callback(results) if calls == 2 || !@chromeAPI.downloads?.search?

    if @chromeAPI.history?.search?
      @chromeAPI.history.search options, (visits) =>
        wrappedCallback(visits)

      if @chromeAPI.downloads?.search?
        if options.startTime && options.endTime
          options =
            startedAfter: new Date(options.startTime).toISOString()
            endedBefore: new Date(options.endTime).toISOString()

        @chromeAPI.downloads.search options || {}, (visits) =>
          wrappedCallback(visits)
    else
      callback(false)


  deleteAll: (callback = ->) ->
    if @chromeAPI.history?.deleteAll?
      @chromeAPI.history.deleteAll ->
        callback()
    else
      callback(false)

  deleteUrl: (url, callback = ->) ->
    throw "Url needed" unless url?

    if @chromeAPI.history?.deleteUrl?
      @chromeAPI.history.deleteUrl url: url, ->
        callback()
    else
      callback(false)

  deleteRange: (range, callback = ->) ->
    throw "Start time needed" unless range.startTime?
    throw "End time needed" unless range.endTime?

    if @chromeAPI.history?.deleteRange?
      @chromeAPI.history.deleteRange range, ->
        callback()
    else
      callback(false)

module.exports = ChromeHistoryAPI
