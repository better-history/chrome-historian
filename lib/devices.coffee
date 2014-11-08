ChromeHistoryAPI = require './chrome_history_api.coffee'
Processor = require './processor.coffee'

class Devices
  constructor: () ->
    @history = new ChromeHistoryAPI()

  fetch: (callback) ->
    @history.sessions (devices) ->
      if devices
        names = for device in devices
          {
            name: device.deviceName
            lastChanged: device.sessions[0]?.lastModified
          }

        callback(names)
      else
        callback(false)

  fetchSessions: (name, callback) ->
    out = []

    # avoid callback scoping issues
    processSession = (session, i, numberOfSessions) ->
      visits = session.window.tabs
      new Processor 'groomer.js', results: visits, (results) ->
        out.push id: session.window.sessionId, sites: results
        callback(out) if i == numberOfSessions

    @history.sessions (devices) ->
      for device in devices
        if device.deviceName == name
          for session, i in device.sessions
            processSession(session, i + 1, device.sessions.length)

module.exports = Devices
