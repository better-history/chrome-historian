class Groomer
  run: (results) ->
    for result in results
      if result.filename?
        result.host = getDomain(result.url)
        result.title = getFileName(result.url)
        result.size = calculateFileSize(result.totalBytes)
        @removeScriptTags result
      else
        result.host = getDomain(result.url)
        result.title = '(No title)' if result.title == '' || !result.title?
        @removeScriptTags result

  removeScriptTags: (result) ->
    regex = /<(.|\n)*?>/ig
    for property in ['title', 'url']
      result[property] = result[property].replace(regex, "")
    result

getDomain = (url) ->
  match = url.match(/\w+:\/\/(.*?)\//)
  if match == null then null else match[0]

getFileName = (url) ->
  match = url.match(/[^//]*$/)
  if match == null then null else match[0]

calculateFileSize = (bytes) ->
  result = Math.round(bytes / 1048576 * 100000) / 100000
  result.toFixed(2)

if onServer?
  module.exports = Groomer
else
  self.addEventListener 'message', (e) ->
    groomer = new Groomer()
    postMessage(groomer.run(e.data.results))
