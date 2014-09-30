ChromeHistoryAPI = require('./chrome_history_api.coffee')
historyAPI = new ChromeHistoryAPI()

window.Historian =
  Devices: require('./devices.coffee')
  Day: require('./day.coffee')
  Search: require('./search.coffee')
  deleteUrl: (args...) ->
    historyAPI.deleteUrl(args...)
  deleteDownload: (args...) ->
    historyAPI.deleteDownload(args...)
  deleteRange: (args...) ->
    historyAPI.deleteRange(args...)
  deleteAll: (args...) ->
    historyAPI.deleteAll(args...)
