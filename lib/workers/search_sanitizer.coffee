class SearchSanitizer
  run: (results, @options) ->
    @terms = @options.text.split(' ')

    out = []

    for result in results
      if out.length >= 1000
        break
      else
        out.push(result) if @verifyTextMatch(result)

    out.sort(@sortByTime)
    out

  verifyTextMatch: (result) ->
    hits = []
    regExp = null

    for term in @terms
      regExp = new RegExp(escapeRegExp(term), "i")
      if result.url.match(regExp) || result.title.match(regExp)
        hits.push(true)

    if @terms? && hits.length == @terms.length then true else false

  sortByTime: (a, b) ->
    aTime = timeOfEvent(a)
    bTime = timeOfEvent(b)
    return -1 if aTime > bTime
    return 1 if aTime < bTime
    0

timeOfEvent = (result) ->
  result.lastVisitTime || new Date(result.startTime).getTime()

escapeRegExp = (str) ->
  str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&")

if onServer?
  module.exports = SearchSanitizer
else
  self.addEventListener 'message', (e) ->
    sanitizer = new SearchSanitizer()
    postMessage(sanitizer.run(e.data.results, e.data.options))
