class RangeSanitizer
  run: (results, @options) ->
    out = []

    for result in results
      out.push(result) if @verifyDateRange(result)

    out.sort(@sortByTime)

    out

  verifyDateRange: (result) ->
    time = timeOfEvent(result)
    time > @options.startTime && time < @options.endTime

  sortByTime: (a, b) ->
    aTime = timeOfEvent(a)
    bTime = timeOfEvent(b)
    return -1 if aTime > bTime
    return 1 if aTime < bTime
    0

timeOfEvent = (result) ->
  result.lastVisitTime || new Date(result.startTime).getTime()

if onServer?
  module.exports = RangeSanitizer
else
  self.addEventListener 'message', (e) ->
    sanitizer = new RangeSanitizer()
    postMessage(sanitizer.run(e.data.results, e.data.options))
