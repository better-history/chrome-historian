@BH = BH ? {}
BH.Workers = BH.Workers ? {}

class BH.Workers.WeekGrouper
  constructor: (@config)->
    @setStartingWeekDay(@config.startingWeekDay)

  setStartingWeekDay: (weekDay) ->
    days =
      sunday: 0
      monday: 1
      tuesday: 2
      wednesday: 3
      thursday: 4
      friday: 5
      saturday: 6

    @startingDay = days[weekDay.toLowerCase()]

  run: (visits) ->
    out = []

    for visit in visits
      time = getWeekStartTime(new Date(visit.lastVisitTime), @startingDay)

      foundAndAdded = false

      for item in out
        if time == item.date.getTime()
          item.visits.push(visit)
          foundAndAdded = true
          break

      unless foundAndAdded
        out.push
          date: new Date(time)
          visits: [visit]

    # sort by date, descending
    out.sort (a, b) -> b.date - a.date

    # fill in week gaps
    for week, index in out
      if previousDate?
        weekDifference = (previousDate - week.date) / 86400000
        if weekDifference > 7
          date = new Date(previousDate - (7 * 86400000))
          out.splice index, 0,
            date: date
            visits: []
          previousDate = date
        else
          previousDate = week.date
      else
        previousDate = week.date

    out

getWeekStartTime = (date, startingDay) ->
  if date.getDay() >= startingDay
    dayDifference = date.getDay() - startingDay
    date.setDate(date.getDate() - dayDifference)
  else
    dayDifference = 7 - (startingDay - date.getDay())
    date.setDate(date.getDate() - dayDifference)

  date.setHours(0,0,0,0)

  date.getTime()

unless onServer?
  self.addEventListener 'message', (e) ->
    weekGrouper = new BH.Workers.WeekGrouper(e.data.config)
    postMessage weekGrouper.run(e.data.visits)
