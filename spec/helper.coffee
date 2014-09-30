global.onServer = true

beforeEach ->
  global.chrome =
    history:
      search: jasmine.createSpy("search")
      deleteRange: jasmine.createSpy("deleteRange")
      deleteUrl: jasmine.createSpy("deleteUrl")
      deleteAll: jasmine.createSpy("deleteAll")
    downloads:
      search: jasmine.createSpy("search")
      erase: jasmine.createSpy("erase")
    sessions:
      getDevices: jasmine.createSpy("getDevices")
