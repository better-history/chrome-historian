module.exports =
  lotsOfVisits: ->
    out = []
    a = 0

    while a < 150
      out.push
        title: "title"
        url: "google.com"
        lastVisitTime: new Date("December 5, 2011 12:00").getTime()
      a++
    out

  outOfOrderVisits: ->
    [
      {
        bytesReceived: 3784539,
        canResume: false,
        danger: "safe",
        endTime: "2011-02-07T19:57:43.000Z",
        exists: false,
        fileSize: 3784539,
        filename: "/Users/roykolak/Downloads/iTerm2_v1_0_0.zip",
        id: 1,
        incognito: false,
        mime: "",
        paused: false,
        referrer: "",
        startTime: "2011-02-07T19:57:41.000Z",
        state: "complete",
        totalBytes: 3784539,
        url: "https://iterm2.googlecode.com/files/iTerm2_v1_0_0.zip"
      }, {
        title: "Great camping"
        url: "great-camping.com"
        lastVisitTime: new Date("September 12, 2010 4:00 pm").getTime()
      }, {
        title: "biking tips"
        url: "biking.com/tips"
        lastVisitTime: new Date("July 2, 2011 4:00 pm").getTime()
      }, {
        title: "amatuer candling making"
        url: "candling.com"
        lastVisitTime: new Date("December 15, 2010 12:00 pm").getTime()
      }
    ]

  variousVisits: ->
    [
      {
        title: "Baking tips"
        url: "baking.com"
        lastVisitTime: new Date("October 12, 2010").getTime()
      }, {
        title: "baking search results"
        url: "google.com/?q=baking"
        lastVisitTime: new Date("December 5, 2010").getTime()
      }, {
        title: "bread making"
        url: "bread.com"
        lastVisitTime: new Date("October 13, 2010").getTime()
      }, {
        bytesReceived: 3784539,
        canResume: false,
        danger: "safe",
        endTime: "2011-02-07T19:57:43.000Z",
        exists: false,
        fileSize: 3784539,
        filename: "/Users/roykolak/Downloads/iTerm2_v1_0_0.zip",
        id: 1,
        incognito: false,
        mime: "",
        paused: false,
        referrer: "",
        startTime: "2011-02-07T19:57:41.000Z",
        state: "complete",
        totalBytes: 3784539,
        url: "https://iterm2.googlecode.com/files/iTerm2_v1_0_0.zip"
      }
    ]
