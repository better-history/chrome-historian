ChromeHistoryAPI = require './chrome_history_api.coffee'
Processor = require './processor.coffee'

class Day
  constructor: (date) ->
    date.setHours(0,0,0,0)
    @startTime = date.getTime()

    date.setHours(23,59,59,999)
    @endTime = date.getTime()

    @history = new ChromeHistoryAPI()

  fetch: (callback = ->) ->
    options =
      startTime: @startTime
      endTime: @endTime
      text: ''
      maxResults: 5000

    @history.query options, (results) =>
      if results
        options =
          options: options
          results: results

        new Processor 'range_sanitizer.js', options, (visits) ->
          new Processor 'groomer.js', results: visits, (visits) ->
            callback(visits)
      else
        callback(false)

  destroy: (callback = ->) ->
    options =
      startTime: @startTime
      endTime: @endTime

    @history.deleteRange options, =>
      callback()

  destroyHour: (hour, callback = ->) ->
    startTime = new Date(@startTime)
    startTime.setHours(hour)

    endTime = new Date(@endTime)
    endTime.setHours(hour)

    options =
      startTime: startTime.getTime()
      endTime: endTime.getTime()

    @history.deleteRange options, =>
      callback()

module.exports = Day
