ChromeHistoryAPI = require '../lib/chrome_history_api.coffee'

describe "BH.Chrome.History", ->
  beforeEach ->
    @history = new ChromeHistoryAPI()

  describe "#query", ->
    it "calls to the chrome history search method with the passed options", ->
      @history.query(maxResults: 0, text: '')
      expect(chrome.history.search).toHaveBeenCalledWith
        maxResults: 0, text: ''
      , jasmine.any(Function)

  describe "#deleteAll", ->
    it "calls to the chrome history delete all method", ->
      @history.deleteAll()
      expect(chrome.history.deleteAll).toHaveBeenCalledWith jasmine.any(Function)

  describe "#deleteUrl", ->
    it "calls the chrome history delete url method with the passed url", ->
      @history.deleteUrl('http://www.google.com')

      expect(chrome.history.deleteUrl).toHaveBeenCalledWith
        url: 'http://www.google.com'
      , jasmine.any(Function)

  describe "#deleteRange", ->
    it "calls the chrome history delete range method with the passed range", ->
      @history.deleteRange
        startTime: new Date('December 4, 2013 CST').getTime()
        endTime: new Date('December 10, 2013 CST').getTime()

      expect(chrome.history.deleteRange).toHaveBeenCalledWith {
        startTime: 1386136800000, endTime: 1386655200000
      }, jasmine.any(Function)
