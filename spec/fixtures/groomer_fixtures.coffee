module.exports =
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

  variousVisits: ->
    [
      {
        title: "Baking tips"
        url: "http://baking.com/recipes"
        lastVisitTime: new Date("October 12, 2010")
      }, {
        title: "baking search results"
        url: "http://google.com/?q=baking"
        lastVisitTime: new Date("December 5, 2010")
      }, {
        url: "http://bread.com/"
        lastVisitTime: new Date("October 13, 2010")
      }
    ]
