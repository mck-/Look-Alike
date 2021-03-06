// Generated by CoffeeScript 1.6.3
(function() {
  var mean,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  exports.distance = function(p1, p2, opts) {
    var attr, dist, val, x, y;
    dist = 0;
    for (attr in p1) {
      val = p1[attr];
      x = val;
      y = p2[attr];
      if ((opts != null ? opts.stdv : void 0) && Object.getOwnPropertyNames(opts.stdv).length > 0) {
        x /= opts.stdv[attr];
        y /= opts.stdv[attr];
      }
      if ((opts != null ? opts.weights : void 0) && Object.getOwnPropertyNames(opts.weights).length > 0) {
        x *= opts.weights[attr];
        y *= opts.weights[attr];
      }
      dist += Math.pow(x - y, 2);
    }
    return Math.sqrt(dist);
  };

  exports.stdv = function(array, key) {
    var a, arr, m, ssqdiff, x, _i, _len;
    if (typeof array[0] !== 'number' && !key) {
      throw new Error('No key parameter provided');
    }
    arr = [];
    if (key) {
      arr = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = array.length; _i < _len; _i++) {
          a = array[_i];
          _results.push(a[key]);
        }
        return _results;
      })();
    } else {
      arr = array;
    }
    m = mean(arr);
    ssqdiff = 0;
    for (_i = 0, _len = arr.length; _i < _len; _i++) {
      x = arr[_i];
      ssqdiff += Math.pow(x - m, 2);
    }
    return Math.sqrt(ssqdiff / array.length);
  };

  exports.allStdvs = function(attributes, objects, key) {
    var attr, o, stdvs, _i, _len;
    stdvs = {};
    if (key) {
      objects = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = objects.length; _i < _len; _i++) {
          o = objects[_i];
          _results.push(key(o));
        }
        return _results;
      })();
    }
    for (_i = 0, _len = attributes.length; _i < _len; _i++) {
      attr = attributes[_i];
      stdvs[attr] = exports.stdv(objects, attr);
    }
    return stdvs;
  };

  exports.medianIndex = function(array) {
    var median, medianVal;
    median = Math.floor(array.length / 2);
    medianVal = array[median];
    return {
      lower: array.indexOf(medianVal),
      upper: array.lastIndexOf(medianVal) + 1,
      median: median
    };
  };

  exports.getSplit = function(objects, bounds, attributes, current_attr, key) {
    var i, identicals, medianObj, o, pickedIndices, x;
    if (key == null) {
      key = function(o) {
        return o;
      };
    }
    medianObj = objects[bounds.median];
    identicals = (function() {
      var _i, _len, _results;
      _results = [];
      for (i = _i = 0, _len = objects.length; _i < _len; i = ++_i) {
        o = objects[i];
        if (attributes.every(function(a) {
          return key(medianObj)[a] === key(o)[a];
        })) {
          _results.push({
            obj: o,
            ind: i
          });
        }
      }
      return _results;
    })();
    pickedIndices = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = identicals.length; _i < _len; _i++) {
        x = identicals[_i];
        _results.push(x.ind);
      }
      return _results;
    })();
    return {
      identicals: (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = identicals.length; _i < _len; _i++) {
          x = identicals[_i];
          _results.push(x.obj);
        }
        return _results;
      })(),
      left: (function() {
        var _i, _len, _results;
        _results = [];
        for (i = _i = 0, _len = objects.length; _i < _len; i = ++_i) {
          o = objects[i];
          if (key(o)[current_attr] < key(medianObj)[current_attr] && __indexOf.call(pickedIndices, i) < 0) {
            _results.push(o);
          }
        }
        return _results;
      })(),
      right: (function() {
        var _i, _len, _results;
        _results = [];
        for (i = _i = 0, _len = objects.length; _i < _len; i = ++_i) {
          o = objects[i];
          if (key(o)[current_attr] >= key(medianObj)[current_attr] && __indexOf.call(pickedIndices, i) < 0) {
            _results.push(o);
          }
        }
        return _results;
      })()
    };
  };

  mean = function(array) {
    var sum;
    sum = array.reduce(function(a, b) {
      return a + b;
    });
    return sum / array.length;
  };

}).call(this);
