class ChromeHistoryAPI
  constructor: (@chromeAPI = chrome) ->

  sessions: (callback = ->) ->
    @chromeAPI.sessions.getDevices (devices) ->
      callback(devices)

  query: (options, callback = ->) ->
    @chromeAPI.history.search options, (visits) =>
      callback(visits)

  deleteAll: (callback = ->) ->
    @chromeAPI.history.deleteAll ->
      callback()

  deleteUrl: (url, callback = ->) ->
    throw "Url needed" unless url?

    @chromeAPI.history.deleteUrl url: url, ->
      callback()

  deleteRange: (range, callback = ->) ->
    throw "Start time needed" unless range.startTime?
    throw "End time needed" unless range.endTime?

    @chromeAPI.history.deleteRange range, => callback()

module.exports = ChromeHistoryAPI
