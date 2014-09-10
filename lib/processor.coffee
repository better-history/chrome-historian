class Processor
  constructor: (file, options = {}, callback) ->
    path = options.path || "scripts/workers/"
    worker = new Worker path + file
    worker.postMessage(options)
    worker.onmessage = (e) ->
      if (e.data.log)
        console.log(e.data.log)
      else
        callback(e.data)
        worker.terminate()

module.exports = Processor
