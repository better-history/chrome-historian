module.exports =
  visitsFor15MinuteInterval: ->
    [
      {
        lastVisitTime: new Date('11/3/12 12:03 PM').getTime()
      }, {
        lastVisitTime: new Date('11/3/12 12:10 PM').getTime()
      }, {
        lastVisitTime: new Date('11/3/12 12:17 PM').getTime()
      }, {
        lastVisitTime: new Date('11/3/12 3:59 PM').getTime()
      }
    ]

  visitsFor30MinuteInterval: ->
    [
      {
        lastVisitTime: new Date('11/3/12 10:05 AM').getTime()
      }, {
        lastVisitTime: new Date('11/3/12 11:45 AM').getTime()
      }, {
        lastVisitTime: new Date('11/3/12 1:02 PM').getTime()
      }, {
        lastVisitTime: new Date('11/3/12 11:29 PM').getTime()
      }
    ]

  visitsFor60MinuteInterval: ->
    [
      {
        lastVisitTime: new Date('11/3/12 10:05 AM').getTime()
      }, {
        lastVisitTime: new Date('11/3/12 10:45 AM').getTime()
      }, {
        lastVisitTime: new Date('11/3/12 3:36 PM').getTime()
      }, {
        lastVisitTime: new Date('11/3/12 3:59 PM').getTime()
      }
    ]
