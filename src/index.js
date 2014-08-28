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
var ChromeHistoryAPI, Day;

ChromeHistoryAPI = require('./chrome_history_api.coffee');

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
        var worker;
        options = {
          options: options,
          results: results
        };
        worker = new Worker('workers/range_sanitizer.js');
        worker.postMessage(options);
        return worker.onmessage = function(e) {
          if (e.data.log) {
            return console.log(e.data.log);
          } else {
            callback(e.data);
            return worker.terminate();
          }
        };
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



},{"./chrome_history_api.coffee":1}],3:[function(require,module,exports){
var ChromeHistorian;

ChromeHistorian = {
  Day: require('./day.coffee')
};



},{"./day.coffee":2}]},{},[3]);
