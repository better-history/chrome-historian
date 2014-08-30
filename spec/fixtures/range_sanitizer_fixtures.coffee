module.exports =
  lotsOfVisits: ->
    out = []
    a = 0

    while a < 150
      out.push
        title: "title"
        url: "google.com"
        lastVisitTime: new Date("December 5, 2011 12:00")
      a++
    out

  visitsWithScriptTag: ->
    [
      {
        title: "test<script>alert(\"yo\")</script>"
        url: "yahoo.com"
        lastVisitTime: new Date("September 12, 2010")
      }, {
        title: "test"
        url: "yahoo.com<script>alert(\"yo\")</script>"
        lastVisitTime: new Date("September 12, 2010")
      }
    ]

  outOfOrderVisits: ->
    [
      {
        title: "Great camping"
        url: "great-camping.com"
        lastVisitTime: new Date("September 12, 2010 4:00 pm")
      }, {
        title: "biking tips"
        url: "biking.com/tips"
        lastVisitTime: new Date("July 2, 2011 4:00 pm")
      }, {
        title: "amatuer candling making"
        url: "candling.com"
        lastVisitTime: new Date("December 15, 2010 12:00 pm")
      }
    ]

  variousVisits: ->
    [
      {
        title: "Baking tips"
        url: "baking.com"
        lastVisitTime: new Date("October 12, 2010")
      }, {
        title: "baking search results"
        url: "google.com/?q=baking"
        lastVisitTime: new Date("December 5, 2010")
      }, {
        title: "bread making"
        url: "bread.com"
        lastVisitTime: new Date("October 13, 2010")
      }
    ]
