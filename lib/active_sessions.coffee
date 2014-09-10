ChromeHistoryAPI = require './chrome_history_api.coffee'
Processor = require './processor.coffee'

class ActiveSessions
  constructor: () ->
    @history = new ChromeHistoryAPI()

  fetchDevices: (callback) ->
    @history.sessions (devices) ->
      names = for device in devices
        {
          name: device.deviceName
          lastChanged: device.sessions[0].lastModified
        }

      callback(names)

  fetchDeviceSession: (name, callback) ->
    @history.sessions (devices) ->
      for device in devices
        if device.deviceName == name
          visits = device.sessions[0].window.tabs
          new Processor 'groomer.js', results: visits, (results) ->
            callback(results)

module.exports = ActiveSessions
