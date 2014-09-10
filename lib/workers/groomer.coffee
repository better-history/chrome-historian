class Groomer
  run: (results) ->
    for result in results
      @removeScriptTags
        url: result.url
        lastVisitTime: result.lastVisitTime
        host: getDomain(result.url)
        title:  result.title || '(No title)'

  removeScriptTags: (result) ->
    regex = /<(.|\n)*?>/ig
    for property in ['title', 'url']
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
