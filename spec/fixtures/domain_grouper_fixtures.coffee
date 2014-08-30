module.exports =
  visitIntervals: ->
    [
      {
        id: '12:00'
        visits: [
          {url: 'http://yahoo.com'},
          {url: 'http://google.com/gmail'},
          {url: 'http://google.com/search'}
        ]
      }, {
        id: '1:00'
        visits: [
          {url: 'http://google.com/gmail'}
        ]
      }, {
        id: '2:00'
        visits: [
          {url: 'http://google.com/gmail'},
          {url: 'https://google.com/search'}
          {url: 'malformatted/yahoo.oops'}
        ]
      }
    ]
