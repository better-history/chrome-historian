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

  it 'extracts the filename and sets it as the title', ->
    visits = Fixtures.variousVisits()
    groomedVisits = @groomer.run(visits)
    expect(groomedVisits[3].title).toEqual 'iTerm2_v1_0_0.zip'

  it 'represents a file\'s size in the correct scale', ->
    visits = Fixtures.variousVisits()
    groomedVisits = @groomer.run(visits)
    expect(groomedVisits[3].size).toEqual '3.61'

  describe "Additional properties", ->
    it "sets a property for the url's host", ->
      visits = Fixtures.variousVisits()
      groomedVisits = @groomer.run(visits)
      expect(groomedVisits[0].host).toEqual 'http://baking.com/'
      expect(groomedVisits[1].host).toEqual 'http://google.com/'
      expect(groomedVisits[2].host).toEqual 'http://bread.com/'
      expect(groomedVisits[3].host).toEqual 'https://iterm2.googlecode.com/'

  describe "Removing script tags", ->
    it "removes any script tags in the title and url", ->
      visits = Fixtures.visitsWithScriptTag()
      groomedVisits = @groomer.run(visits)

      expect(groomedVisits[0].title).toEqual("testalert(\"yo\")")
      expect(groomedVisits[1].url).toEqual("yahoo.comalert(\"yo\")")
      expect(groomedVisits[2].url).toEqual("https://iterm2.googlecode.com/files/iTerm2_v1_0_0.zip")
