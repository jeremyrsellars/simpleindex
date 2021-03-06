// Generated by CoffeeScript 1.3.3
(function() {
  var LowerCaseFilter;

  LowerCaseFilter = (function() {

    function LowerCaseFilter(subFilter) {
      this.subFilter = subFilter;
      return;
    }

    LowerCaseFilter.prototype.filter = function(terms) {
      var term;
      if (this.subFilter != null) {
        terms = this.subFilter.filter(terms);
      }
      return (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = terms.length; _i < _len; _i++) {
          term = terms[_i];
          _results.push(term.toLowerCase());
        }
        return _results;
      })();
    };

    return LowerCaseFilter;

  })();

  module.exports = {
    LowerCaseFilter: LowerCaseFilter
  };

}).call(this);
