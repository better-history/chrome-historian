@BH = BH ? {}
BH.Workers = BH.Workers ? {}

class BH.Workers.TimeGrouper
  constructor: ->
    @arrangedVisits = []

  run: (@visits, @options) ->
    @interval = @options.interval

    for visit in @visits
      date = new Date(visit.lastVisitTime)
      interval = @calculateInterval(date)
      index = @intervals().indexOf(interval)

      if index == -1
        group = @createIntervalGroup(date, interval)
        @arrangedVisits.push group
        index = @arrangedVisits.length - 1

      @arrangedVisits[index].visits.push(visit)

    @arrangedVisits

  createIntervalGroup: (date, time) ->
    datetime = "#{date.getMonth()+1}/#{date.getDate()}/#{date.getFullYear()} #{time}"

    datetime: new Date(datetime)
    id: time
    visits:[]

  intervals: ->
    for arrangedVisit in @arrangedVisits
      arrangedVisit.id

  calculateInterval: (date) ->
    minutes = @roundMinuteToInterval date.getMinutes()
    hour = date.getHours()
    if minutes == '00'
      if hour == 23
        hour = 0
      else
        hour = hour + 1
    "#{hour}:#{minutes}"

  roundMinuteToInterval: (minutes) ->
    minutes = Math.ceil(minutes / @interval) * @interval
    if minutes == 60
      return '00'
    if minutes == 0
      return '15'
    minutes

unless onServer?
  self.addEventListener 'message', (e) ->
    timeGrouper = new BH.Workers.TimeGrouper()
    options = interval: e.data.interval
    postMessage timeGrouper.run(e.data.visits, options)
