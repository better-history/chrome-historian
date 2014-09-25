module.exports =
  lotsOfVisits: ->
    out = []
    a = 0

    while a < 1001
      out.push
        title: "title"
        url: "google.com"
        lastVisitTime: new Date()
      a++
    out

  visitsWithScriptTag: ->
    [
      {
        title: "test<script>alert(\"yo\")</script>"
        url: "yahoo.com"
        lastVisitTime: new Date("September 12, 2010 4:00 pm")
      }, {
        title: "test"
        url: "yahoo.com<script>alert(\"yo\")</script>"
        lastVisitTime: new Date("September 12, 2010 3:00 pm")
      }
    ]

  visitsWithSpecialCharacters: ->
    [
      {
        title: "(C++ tutorials)"
        url: "http://c-plusplus.com"
        lastVisitTime: new Date("September 12, 2010 4:00 pm")
      }, {
        title: "I got a C+ on my test"
        url: "http://tests.com/c"
        lastVisitTime: new Date("September 12, 2010 3:00 pm")
      }, {
        title: "I got a D+ on my test"
        url: "http://tests.com/d"
        lastVisitTime: new Date("September 12, 2010 3:00 pm")
      }
    ]

  outOfOrderVisits: ->
    [
      {
        title: "Great camping"
        url: "great-camping.com"
        lastVisitTime: new Date("September 12, 2010 4:00 pm")
      }, {
        title: "biking tips for camping"
        url: "biking.com/camping_tips"
        lastVisitTime: new Date("July 2, 2011 4:00 pm")
      }, {
        title: "camping"
        url: "camping.com"
        lastVisitTime: new Date("December 15, 2010 12:00 pm")
      }
    ]

  variousVisits: ->
    [
      {
        title: "hit september"
        url: "google.com"
      }, {
        title: "September something"
        url: "google.com"
        lastVisitTime: new Date("December 2, 2010")
      }, {
        title: "lame"
        url: "google.com/hit"
      }, {
        title: "Normal something"
        url: "google.com/september"
        lastVisitTime: new Date("July 2, 2010")
      }, {
        title: "no match"
        url: "google.com/something"
      }, {
        title: "something"
        url: "yahoo.com"
        lastVisitTime: new Date("September 12, 2010")
      }
    ]
