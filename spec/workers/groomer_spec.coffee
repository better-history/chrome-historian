Fixtures = require '../fixtures/groomer_fixtures'
Groomer = require '../../lib/workers/groomer'

describe "Groomer WebWorker", ->
  beforeEach ->
    @visits = []
    @groomer = new Groomer()

  it "sets a default title when no title is set", ->
    visits = Fixtures.variousVisits()
    groomedVisits = @groomer.run(visits)
    expect(groomedVisits[0].title).toEqual 'Baking tips'
    expect(groomedVisits[2].title).toEqual '(No title)'

  describe "Additional properties", ->
    it "sets a property called location to be equal to the url", ->
      visits = Fixtures.variousVisits()
      groomedVisits = @groomer.run(visits)
      expect(groomedVisits[0].location).toEqual 'http://baking.com/recipes'

    it "sets a property for the url's host", ->
      visits = Fixtures.variousVisits()
      groomedVisits = @groomer.run(visits)
      expect(groomedVisits[0].host).toEqual 'http://baking.com/'
      expect(groomedVisits[1].host).toEqual 'http://google.com/'
      expect(groomedVisits[2].host).toEqual 'http://bread.com/'

  describe "Removing script tags", ->
    it "removes any script tags in the title and url", ->
      visits = Fixtures.visitsWithScriptTag()
      groomedVisits = @groomer.run(visits)

      expect(groomedVisits[0].title).toEqual("testalert(\"yo\")")
      expect(groomedVisits[1].location).toEqual("yahoo.comalert(\"yo\")")
