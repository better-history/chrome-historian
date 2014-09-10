class RangeSanitizer
  run: (results, @options) ->
    out = []

    for result in results
      out.push(result) if @verifyDateRange(result)

    out.sort(@sortByTime)

    out

  verifyDateRange: (result) ->
    result.lastVisitTime > @options.startTime && result.lastVisitTime < @options.endTime

  sortByTime: (a, b) ->
    return -1 if a.lastVisitTime > b.lastVisitTime
    return 1 if a.lastVisitTime < b.lastVisitTime
    0

if onServer?
  module.exports = RangeSanitizer
else
  self.addEventListener 'message', (e) ->
    sanitizer = new RangeSanitizer()
    postMessage(sanitizer.run(e.data.results, e.data.options))
