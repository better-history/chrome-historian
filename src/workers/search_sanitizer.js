// Generated by CoffeeScript 1.7.1
(function() {
  var SearchSanitizer;

  SearchSanitizer = (function() {
    function SearchSanitizer() {}

    SearchSanitizer.prototype.run = function(results, options) {
      var out, result, _i, _len;
      this.options = options;
      this.terms = this.options.text.split(' ');
      out = [];
      for (_i = 0, _len = results.length; _i < _len; _i++) {
        result = results[_i];
        if (out.length >= 1000) {
          break;
        } else {
          if (this.verifyTextMatch(result)) {
            out.push(result);
          }
        }
      }
      out.sort(this.sortByTime);
      return out;
    };

    SearchSanitizer.prototype.verifyTextMatch = function(result) {
      var hits, regExp, term, _i, _len, _ref;
      hits = [];
      regExp = null;
      _ref = this.terms;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        term = _ref[_i];
        regExp = new RegExp(term, "i");
        if (result.url.match(regExp) || result.title.match(regExp)) {
          hits.push(true);
        }
      }
      if ((this.terms != null) && hits.length === this.terms.length) {
        return true;
      } else {
        return false;
      }
    };

    SearchSanitizer.prototype.sortByTime = function(a, b) {
      if (a.lastVisitTime > b.lastVisitTime) {
        return -1;
      }
      if (a.lastVisitTime < b.lastVisitTime) {
        return 1;
      }
      return 0;
    };

    return SearchSanitizer;

  })();

  if (typeof onServer !== "undefined" && onServer !== null) {
    module.exports = SearchSanitizer;
  } else {
    self.addEventListener('message', function(e) {
      var sanitizer;
      sanitizer = new SearchSanitizer();
      return postMessage(sanitizer.run(e.data.results, e.data.options));
    });
  }

}).call(this);
