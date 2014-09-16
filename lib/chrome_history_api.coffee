class ChromeHistoryAPI
  constructor: (@chromeAPI = chrome) ->

  sessions: (callback = ->) ->
    if @chromeAPI.sessions?.getDevices?
      @chromeAPI.sessions.getDevices (devices) ->
        callback(devices)
    else
      callback(false)

  query: (options, callback = ->) ->
    if @chromeAPI.history?.search?
      @chromeAPI.history.search options, (visits) =>
        callback(visits)
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
