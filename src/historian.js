(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var ChromeHistoryAPI;

ChromeHistoryAPI = (function() {
  function ChromeHistoryAPI(chromeAPI) {
    this.chromeAPI = chromeAPI != null ? chromeAPI : chrome;
  }

  ChromeHistoryAPI.prototype.query = function(options, callback) {
    if (callback == null) {
      callback = function() {};
    }
    return this.chromeAPI.history.search(options, (function(_this) {
      return function(visits) {
        return callback(visits);
      };
    })(this));
  };

  ChromeHistoryAPI.prototype.deleteAll = function(callback) {
    if (callback == null) {
      callback = function() {};
    }
    return this.chromeAPI.history.deleteAll(function() {
      return callback();
    });
  };

  ChromeHistoryAPI.prototype.deleteUrl = function(url, callback) {
    if (callback == null) {
      callback = function() {};
    }
    if (url == null) {
      throw "Url needed";
    }
    return this.chromeAPI.history.deleteUrl({
      url: url
    }, function() {
      return callback();
    });
  };

  ChromeHistoryAPI.prototype.deleteRange = function(range, callback) {
    if (callback == null) {
      callback = function() {};
    }
    if (range.startTime == null) {
      throw "Start time needed";
    }
    if (range.endTime == null) {
      throw "End time needed";
    }
    return this.chromeAPI.history.deleteRange(range, (function(_this) {
      return function() {
        return callback();
      };
    })(this));
  };

  return ChromeHistoryAPI;

})();

module.exports = ChromeHistoryAPI;



},{}],2:[function(require,module,exports){
var ChromeHistoryAPI, Day, Processor;

ChromeHistoryAPI = require('./chrome_history_api.coffee');

Processor = require('./processor.coffee');

Day = (function() {
  function Day(date) {
    date.setHours(0, 0, 0, 0);
    this.startTime = date.getTime();
    date.setHours(23, 59, 59, 999);
    this.endTime = date.getTime();
    this.history = new ChromeHistoryAPI();
  }

  Day.prototype.fetch = function(callback) {
    var options;
    if (callback == null) {
      callback = function() {};
    }
    options = {
      startTime: this.startTime,
      endTime: this.endTime,
      text: '',
      maxResults: 5000
    };
    return this.history.query(options, (function(_this) {
      return function(results) {
        options = {
          options: options,
          results: results
        };
        return new Processor('range_sanitizer.js', options, function(visits) {
          return callback(visits);
        });
      };
    })(this));
  };

  Day.prototype.destroy = function(callback) {
    var options;
    if (callback == null) {
      callback = function() {};
    }
    options = {
      startTime: this.startTime,
      endTime: this.endTime
    };
    return this.history.deleteRange(options, (function(_this) {
      return function() {
        return callback();
      };
    })(this));
  };

  Day.prototype.destroyHour = function(hour, callback) {
    var endTime, options, startTime;
    if (callback == null) {
      callback = function() {};
    }
    startTime = new Date(this.startTime);
    startTime.setHours(hour);
    endTime = new Date(this.endTime);
    endTime.setHours(hour);
    options = {
      startTime: startTime.getTime(),
      endTime: endTime.getTime()
    };
    return this.history.deleteRange(options, (function(_this) {
      return function() {
        return callback();
      };
    })(this));
  };

  return Day;

})();

module.exports = Day;



},{"./chrome_history_api.coffee":1,"./processor.coffee":4}],3:[function(require,module,exports){
var ChromeHistoryAPI, historyAPI,
  __slice = [].slice;

ChromeHistoryAPI = require('./chrome_history_api.coffee');

historyAPI = new ChromeHistoryAPI();

window.Historian = {
  Day: require('./day.coffee'),
  Search: require('./search.coffee'),
  deleteUrl: function() {
    var args;
    args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    return historyAPI.deleteUrl.apply(historyAPI, args);
  },
  deleteRange: function() {
    var args;
    args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    return historyAPI.deleteRange.apply(historyAPI, args);
  },
  deleteAll: function() {
    var args;
    args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    return historyAPI.deleteAll.apply(historyAPI, args);
  }
};



},{"./chrome_history_api.coffee":1,"./day.coffee":2,"./search.coffee":5}],4:[function(require,module,exports){
var Processor;

Processor = (function() {
  function Processor(file, options, callback) {
    var path, worker;
    path = options.path || "scripts/workers/";
    worker = new Worker(path + file);
    worker.postMessage(options);
    worker.onmessage = function(e) {
      if (e.data.log) {
        return console.log(e.data.log);
      } else {
        callback(e.data);
        return worker.terminate();
      }
    };
  }

  return Processor;

})();

module.exports = Processor;



},{}],5:[function(require,module,exports){
var ChromeHistoryAPI, Processor, Search, fillInVisit, getDomain, parse;

ChromeHistoryAPI = require('./chrome_history_api.coffee');

Processor = require('./processor.coffee');

Search = (function() {
  function Search(query) {
    this.query = query;
    this.history = new ChromeHistoryAPI();
  }

  Search.prototype.fetch = function(options, callback) {
    var defaultOptions, endTime, startAtResult, startTime;
    if (callback == null) {
      callback = function() {};
    }
    defaultOptions = {
      text: '',
      startTime: 0,
      maxResults: 5000
    };
    options = _.extend(defaultOptions, options);
    startTime = options.startTime, endTime = options.endTime;
    startAtResult = options.startAtResult;
    delete options.startAtResult;
    return chrome.storage.local.get('lastSearchCache', (function(_this) {
      return function(data) {
        var cache;
        cache = data.lastSearchCache;
        if ((cache != null ? cache.query : void 0) === _this.query && (cache != null ? cache.startTime : void 0) === startTime && (cache != null ? cache.endTime : void 0) === endTime && !startAtResult) {
          return callback(cache.results, new Date(cache.datetime));
        } else {
          return _this.history.query(options, function(history) {
            options = {
              options: {
                text: _this.query
              },
              results: history
            };
            return new Processor('search_sanitizer.js', options, function(results) {
              var setCache;
              setCache = function(results) {
                return chrome.storage.local.set({
                  lastSearchCache: {
                    results: results,
                    datetime: new Date().getTime(),
                    query: _this.query,
                    startTime: startTime,
                    endTime: endTime
                  }
                });
              };
              if (startTime && endTime) {
                return new Processor('range_sanitizer.js', {
                  options: {
                    startTime: startTime,
                    endTime: endTime
                  },
                  results: results
                }, function(sanitizedResults) {
                  setCache(sanitizedResults);
                  return callback(parse(sanitizedResults));
                });
              } else {
                setCache(results);
                return callback(parse(results));
              }
            });
          });
        }
      };
    })(this));
  };

  Search.prototype.expireCache = function() {
    return chrome.storage.local.remove('lastSearchCache');
  };

  Search.prototype.deleteUrl = function(url, callback) {
    this.history.deleteUrl(url, function() {
      return callback();
    });
    return chrome.storage.local.get('lastSearchCache', (function(_this) {
      return function(data) {
        var results;
        results = data.lastSearchCache.results;
        data.lastSearchCache.results = _.reject(results, function(visit) {
          return visit.url === url;
        });
        return chrome.storage.local.set(data);
      };
    })(this));
  };

  Search.prototype.destroy = function(options, callback) {
    if (options == null) {
      options = {};
    }
    if (callback == null) {
      callback = function() {};
    }
    return this.fetch(options, (function(_this) {
      return function(history) {
        var i, visit, _i, _len, _results;
        _results = [];
        for (i = _i = 0, _len = history.length; _i < _len; i = ++_i) {
          visit = history[i];
          _results.push(_this.history.deleteUrl(visit.url, function() {
            if (i === history.length) {
              _this.expireCache();
              return callback();
            }
          }));
        }
        return _results;
      };
    })(this));
  };

  return Search;

})();

parse = function(visits) {
  var i, visit, _i, _len, _results;
  _results = [];
  for (i = _i = 0, _len = visits.length; _i < _len; i = ++_i) {
    visit = visits[i];
    _results.push(fillInVisit(visit));
  }
  return _results;
};

fillInVisit = function(visit) {
  visit.host = getDomain(visit.url);
  visit.location = visit.url;
  visit.path = visit.url.replace(visit.domain, '');
  if (visit.title === '') {
    visit.title = '(No Title)';
  }
  visit.name = visit.title;
  return visit;
};

getDomain = function(url) {
  var match;
  match = url.match(/\w+:\/\/(.*?)\//);
  if (match === null) {
    return null;
  } else {
    return match[0];
  }
};

module.exports = Search;



},{"./chrome_history_api.coffee":1,"./processor.coffee":4}]},{},[3]);
