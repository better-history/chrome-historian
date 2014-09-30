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
        url: "https://iterm2.googlecode.com/files/iTerm2_v1<script></script>_0_0.zip"
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
        title: ""
        lastVisitTime: new Date("October 13, 2010")
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
