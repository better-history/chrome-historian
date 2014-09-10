Fixtures = require '../fixtures/range_sanitizer_fixtures'
RangeSanitizer = require '../../lib/workers/range_sanitizer'

describe "RangeSanitizer WebWorker", ->
  beforeEach ->
    @visits = []
    @rangeSanitizer = new RangeSanitizer()

  it "returns as many results as found", ->
    options =
      startTime: new Date("December 5, 2011 0:00")
      endTime: new Date("December 5, 2011 23:59")

    visits = Fixtures.lotsOfVisits()
    sanitizedVisits = @rangeSanitizer.run(visits, options)
    expect(sanitizedVisits.length).toEqual(150)

  it "orders the matched results by lastVisitTime", ->
    options =
      startTime: new Date("June 1, 2010")
      endTime: new Date("October 14, 2011")

    visits = Fixtures.outOfOrderVisits()
    sanitizedVisits = @rangeSanitizer.run(visits, options)

    titles = (visit.title for visit in sanitizedVisits)
    expect(titles).toEqual ['biking tips', 'amatuer candling making', 'Great camping']

  it "matches results by checking if the date falls between the searched ranges", ->
    options =
      startTime: new Date("October 1, 2010")
      endTime: new Date("October 14, 2010")

    visits = Fixtures.variousVisits()
    sanitizedVisits = @rangeSanitizer.run(visits, options)

    titles = (visit.title for visit in sanitizedVisits)
    expect(titles).toEqual ['bread making', 'Baking tips']
