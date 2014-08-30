module.exports =
  lotsOfVisits: ->
    out = []
    a = 0

    while a < 1001
      out.push
        title: "title"
        url: "google.com"
        lastVisitTime: new Date()
        extendedDate: 'the extended date'
        time: 'Monday, July 4th, 2010'
      a++
    out

  visitsWithScriptTag: ->
    [
      {
        title: "test<script>alert(\"yo\")</script>"
        url: "yahoo.com"
        lastVisitTime: new Date("September 12, 2010 4:00 pm")
        extendedDate: 'September 12th'
        time: '4:00 pm'
      }, {
        title: "test"
        url: "yahoo.com<script>alert(\"yo\")</script>"
        lastVisitTime: new Date("September 12, 2010 3:00 pm")
        extendedDate: 'September 12th'
        time: '3:00 pm'
      }
    ]

  outOfOrderVisits: ->
    [
      {
        title: "Great camping"
        url: "great-camping.com"
        lastVisitTime: new Date("September 12, 2010 4:00 pm")
        extendedDate: 'September 12th'
        time: '4:00 pm'
      }, {
        title: "biking tips for camping"
        url: "biking.com/camping_tips"
        lastVisitTime: new Date("July 2, 2011 4:00 pm")
        extendedDate: 'July 2nd'
        time: '4:00 pm'
      }, {
        title: "camping"
        url: "camping.com"
        lastVisitTime: new Date("December 15, 2010 12:00 pm")
        extendedDate: 'December 15th'
        time: '12:00pm'
      }
    ]

  variousVisits: ->
    [
      {
        title: "hit september"
        url: "google.com"
        extendedDate: 'the extended date'
        time: 'the time'
      }, {
        title: "September something"
        url: "google.com"
        lastVisitTime: new Date("December 2, 2010")
        extendedDate: 'the extended date'
        time: '12:30PM'
      }, {
        title: "lame"
        url: "google.com/hit"
        extendedDate: 'the extended date'
        time: 'the time'
      }, {
        title: "Normal something"
        url: "google.com/september"
        lastVisitTime: new Date("July 2, 2010")
        extendedDate: 'the extended date'
        time: '12:30PM'
      }, {
        title: "no match"
        url: "google.com/something"
        extendedDate: 'the extended date'
        time: 'the time'
      }, {
        title: "something"
        url: "yahoo.com"
        lastVisitTime: new Date("September 12, 2010")
        extendedDate: 'September'
        time: '12:30PM'
      }
    ]
