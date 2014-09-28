class Groomer
  run: (results) ->
    for result in results
      if result.filename?
        result.host = getDomain(result.url)
        @removeScriptTags result
      else
        @removeScriptTags
          url: result.url
          lastVisitTime: result.lastVisitTime
          host: getDomain(result.url)
          title:  result.title || '(No title)'

  removeScriptTags: (result) ->
    regex = /<(.|\n)*?>/ig
    for property in ['title', 'url']
      if result[property]?
        result[property] = result[property].replace(regex, "")
    result

getDomain = (url) ->
  match = url.match(/\w+:\/\/(.*?)\//)
  if match == null then null else match[0]

if onServer?
  module.exports = Groomer
else
  self.addEventListener 'message', (e) ->
    groomer = new Groomer()
    postMessage(groomer.run(e.data.results))
