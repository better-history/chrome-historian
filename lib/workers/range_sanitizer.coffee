class RangeSanitizer
  run: (results, @options) ->
    prunedResults = []
    for result in results
      if @verifyDateRange(result)
        result.location = result.url
        result.host = getDomain(result.url)
        result.title ||=  '(No title)'
        @removeScriptTags(result)
        prunedResults.push(result)

    prunedResults.sort(@sortByTime)
    prunedResults

  verifyDateRange: (result) ->
    result.lastVisitTime > @options.startTime && result.lastVisitTime < @options.endTime

  removeScriptTags: (result) ->
    regex = /<(.|\n)*?>/ig
    for property in ['title', 'url', 'location']
      result[property] = result[property].replace(regex, "")

  setAdditionalProperties: (result) ->
    result.location = result.url

  sortByTime: (a, b) ->
    return -1 if a.lastVisitTime > b.lastVisitTime
    return 1 if a.lastVisitTime < b.lastVisitTime
    0

getDomain = (url) ->
  match = url.match(/\w+:\/\/(.*?)\//)
  if match == null then null else match[0]

if self?
  self.addEventListener 'message', (e) ->
    sanitizer = new RangeSanitizer()
    postMessage(sanitizer.run(e.data.results, e.data.options))
