"use strict";
var assert, octarine;

assert = require('assert');

octarine = require('../master');

describe("octarine(fn)", function() {
  it("should returns number", function() {
    var coroutine;
    this.slow(1000);
    coroutine = function() {
      return 1983;
    };
    return octarine(coroutine).then(function(res) {
      return assert.equal(res, 1983);
    });
  });
  it("should returns string", function() {
    var coroutine;
    this.slow(1000);
    coroutine = function() {
      return "The Colour of Magic";
    };
    return octarine(coroutine).then(function(res) {
      return assert.equal(res, "The Colour of Magic");
    });
  });
  it("should returns array", function() {
    var coroutine;
    this.slow(1000);
    coroutine = function() {
      return ["Rincewind", "Twoflower", "The Luggage"];
    };
    return octarine(coroutine).then(function(res) {
      return assert.deepEqual(res, ["Rincewind", "Twoflower", "The Luggage"]);
    });
  });
  it("should returns object", function() {
    var coroutine;
    this.slow(1000);
    coroutine = function() {
      return {
        "wizzard": "Rincewind",
        "tourist": "Twoflower",
        "chest": "The Luggage"
      };
    };
    return octarine(coroutine).then(function(res) {
      return assert.deepEqual(res, {
        "wizzard": "Rincewind",
        "tourist": "Twoflower",
        "chest": "The Luggage"
      });
    });
  });
  return it("should returns function", function() {
    var coroutine;
    this.slow(1000);
    coroutine = function() {
      return function(name) {
        switch (name) {
          case "Rincewind":
            return "wizzard";
          case "Twoflower":
            return "tourist";
          case "The Luggage":
            return "chest";
          default:
            return "oops";
        }
      };
    };
    return octarine(coroutine).then(function(res) {
      assert.equal(res("Rincewind"), "wizzard");
      assert.equal(res("Twoflower"), "tourist");
      assert.equal(res("The Luggage"), "chest");
      return assert.equal(res("???"), "oops");
    });
  });
});

describe("octarine(fn, attr)", function() {
  it("should returns number", function() {
    var coroutine;
    this.slow(1000);
    coroutine = function(year) {
      return year;
    };
    return octarine(coroutine, [1983]).then(function(res) {
      return assert.equal(res, 1983);
    });
  });
  it("should returns string", function() {
    var coroutine;
    this.slow(1000);
    coroutine = function() {
      var args;
      args = [].slice.call(arguments, 0);
      return args.join(" ");
    };
    return octarine(coroutine, ["The", "Colour", "of", "Magic"]).then(function(res) {
      return assert.equal(res, "The Colour of Magic");
    });
  });
  it("should returns array", function() {
    var coroutine;
    this.slow(1000);
    coroutine = function(id) {
      var items;
      items = ["Rincewind", "Twoflower", "The Luggage"];
      return [items[id]];
    };
    return octarine(coroutine, [1]).then(function(res) {
      return assert.deepEqual(res, ["Twoflower"]);
    });
  });
  return it("should returns object", function() {
    var coroutine;
    this.slow(1000);
    coroutine = function(role) {
      var item, items, obj;
      items = {
        "wizzard": "Rincewind",
        "tourist": "Twoflower",
        "chest": "The Luggage"
      };
      item = items[role];
      return (
        obj = {},
        obj["" + role] = item,
        obj
      );
    };
    return octarine(coroutine, ["wizzard"]).then(function(res) {
      return assert.deepEqual(res, {
        "wizzard": "Rincewind"
      });
    });
  });

  /**
   * @todo  настроить возврат функции
   */
});
