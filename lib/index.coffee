ChromeHistoryAPI = require('./chrome_history_api.coffee')
historyAPI = new ChromeHistoryAPI()

window.Historian =
  ActiveSessions: require('./active_sessions.coffee')
  Day: require('./day.coffee')
  Search: require('./search.coffee')
  deleteUrl: (args...) ->
    historyAPI.deleteUrl(args...)
  deleteRange: (args...) ->
    historyAPI.deleteRange(args...)
  deleteAll: (args...) ->
    historyAPI.deleteAll(args...)
