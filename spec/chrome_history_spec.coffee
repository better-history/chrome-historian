ChromeHistoryAPI = require '../lib/chrome_history_api.coffee'

describe "BH.Chrome.History", ->
  beforeEach ->
    @history = new ChromeHistoryAPI()
    @callback = jasmine.createSpy()

  describe "#sessions", ->
    it "calls to the chrome sessions getDevices method", ->
      @history.sessions()
      expect(chrome.sessions.getDevices).toHaveBeenCalledWith jasmine.any(Function)

    it "calls the callback with 'false' when getDevices is not found on the chrome API", ->
      delete @history.chromeAPI.sessions.getDevices
      @history.sessions(@callback)
      expect(@callback).toHaveBeenCalledWith false

  describe "#query", ->
    it "calls to the chrome history search method with the passed options", ->
      @history.query(maxResults: 0, text: '')
      expect(chrome.history.search).toHaveBeenCalledWith
        maxResults: 0, text: ''
      , jasmine.any(Function)

    it "calls to the chrome download method with the readjusted passed options", ->
      @history.query(startTime: '22222222', endTime: '33333333')
      expect(chrome.downloads.search).toHaveBeenCalledWith
        startedAfter: '22222222'
      , jasmine.any(Function)

    it 'calls the callback with the concated results from history and downloads', ->
      @history.chromeAPI.history.search.andCallFake (options, callback) ->
        callback(['history'])
      @history.chromeAPI.downloads.search.andCallFake (options, callback) ->
        callback(['downloads'])

      @history.query({}, @callback)
      expect(@callback).toHaveBeenCalledWith ['history', 'downloads']



    describe 'when the chrome download method is not supported (and the history method is)', ->
      beforeEach ->
        delete @history.chromeAPI.downloads.search
        @history.chromeAPI.history.search.andCallFake (options, callback) ->
          callback()

      it 'still works', ->
        @history.query(maxResults: 0, text: '', @callback)
        expect(@callback).toHaveBeenCalled()

    describe 'when the chrome search method is not supported', ->
      beforeEach ->
        delete @history.chromeAPI.history.search

      it "calls the callback with 'false' when search is not found on the chrome API", ->
        @history.query(maxResults: 0, text: '', @callback)
        expect(@callback).toHaveBeenCalledWith false

  describe "#deleteAll", ->
    it "calls to the chrome history delete all method", ->
      @history.deleteAll()
      expect(chrome.history.deleteAll).toHaveBeenCalledWith jasmine.any(Function)

    it "calls the callback with 'false' when deleteAll is not found on the chrome API", ->
      delete @history.chromeAPI.history.deleteAll
      @history.deleteAll(@callback)
      expect(@callback).toHaveBeenCalledWith false

  describe "#deleteUrl", ->
    it "calls the chrome history delete url method with the passed url", ->
      @history.deleteUrl('http://www.google.com')

      expect(chrome.history.deleteUrl).toHaveBeenCalledWith
        url: 'http://www.google.com'
      , jasmine.any(Function)

    it "calls the callback with 'false' when deleteUrl is not found on the chrome API", ->
      delete @history.chromeAPI.history.deleteUrl
      @history.deleteUrl('http://www.google.com', @callback)
      expect(@callback).toHaveBeenCalledWith false

  describe "#deleteRange", ->
    beforeEach ->
      @options =
        startTime: new Date('December 4, 2013 CST').getTime()
        endTime: new Date('December 10, 2013 CST').getTime()

    it "calls the chrome history delete range method with the passed range", ->
      @history.deleteRange @options

      expect(chrome.history.deleteRange).toHaveBeenCalledWith {
        startTime: 1386136800000, endTime: 1386655200000
      }, jasmine.any(Function)

    it "calls the callback with 'false' when deleteRange is not found on the chrome API", ->
      delete @history.chromeAPI.history.deleteRange
      @history.deleteRange @options, @callback
      expect(@callback).toHaveBeenCalledWith false
