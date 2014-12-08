class SearchSanitizer
  run: (results, @options) ->
    if @options.text.match(/^\/.*\/$/)
      @terms = @options.text.slice(1, -1)
    else
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

    if Array.isArray(@terms)
      for term in @terms
        regExp = new RegExp(escapeRegExp(term), "i")
        if result.url.match(regExp) || result.title.match(regExp)
          hits.push(true)

      if hits.length == @terms.length
        return true
      else
        return false

    else
      regExp = new RegExp(@terms)
      if result.url.match(regExp) || result.title.match(regExp)
        return true


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
