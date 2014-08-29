@BH = BH ? {}
BH.Workers = BH.Workers ? {}

class BH.Workers.DayGrouper
  constructor: ->
    @days = [
      {
        name: 'Sunday'
        visits: []
      }, {
        name: 'Monday'
        visits: []
      }, {
        name: 'Tuesday'
        visits: []
      }, {
        name: 'Wednesday'
        visits: []
      }, {
        name: 'Thursday'
        visits: []
      }, {
        name: 'Friday'
        visits: []
      }, {
        name: 'Saturday'
        visits: []
      }
    ]

  run: (visits) ->
    for visit in visits
      dayName = indexToDay(new Date(visit.lastVisitTime).getDay())
      for day, index in @days
        if day.name == dayName
          @days[index].visits.push visit
          break
    @days

indexToDay = (index) ->
  days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ]
  days[index]

unless onServer?
  self.addEventListener 'message', (e) ->
    dayGrouper = new BH.Workers.DayGrouper()
    postMessage dayGrouper.run(e.data.visits)
