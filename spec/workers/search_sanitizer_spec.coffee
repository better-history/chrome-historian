Fixtures = require '../fixtures/search_sanitizer_fixtures'
SearchSanitizer = require '../../lib/workers/search_sanitizer'

describe "SearchSanitizer WebWorker", ->
  beforeEach ->
    @searchSanitizer = new SearchSanitizer()

  it "returns a max of 1000 results when searching", ->
    visits = Fixtures.lotsOfVisits()
    sanitizedVisits = @searchSanitizer.run(visits, text: 'title')

    expect(sanitizedVisits.length).toEqual(1000)

  it "matches results by checking if the search term exists in the title, url, time, or date of the visit", ->
    visits = Fixtures.variousVisits()
    sanitizedVisits = @searchSanitizer.run(visits, text: 'september something')

    titles = (visit.title for visit in sanitizedVisits)
    expect(titles).toEqual ['September something', 'Normal something']

  it "orders the matched results by lastVisitTime", ->
    visits = Fixtures.outOfOrderVisits()
    sanitizedVisits = @searchSanitizer.run(visits, text: 'camping')

    titles = (visit.title for visit in sanitizedVisits)
    expect(titles).toEqual ['biking tips for camping', 'camping', 'Great camping']

  it "escapes special characters", ->
    visits = Fixtures.visitsWithSpecialCharacters()
    sanitizedVisits = @searchSanitizer.run(visits, text: '(c+')

    titles = (visit.title for visit in sanitizedVisits)
    expect(titles).toEqual ['(C++ tutorials)']

  it "accepts regexs", ->
    visits = Fixtures.variousVisits()
    sanitizedVisits = @searchSanitizer.run(visits, text: '/september/')

    expect(sanitizedVisits.length).toEqual 2
