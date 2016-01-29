"use strict";
var Master, Promise, _, cp, master, utils,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

cp = require('child_process');

Promise = require('bluebird');

_ = require('lodash');

utils = require('./utils');


/**
 * @todo Решить вопрос с ошибками в сопрограммах
 */

Master = (function() {
  function Master() {
    this.start = bind(this.start, this);
    this._unwrapResult = bind(this._unwrapResult, this);
    this._wrapFunction = bind(this._wrapFunction, this);
    this.workers = [];
    this.options = {
      cmd: "node"
    };
  }

  Master.prototype._wrapFunction = function(fn, args) {
    var answer;
    if (args == null) {
      args = [];
    }
    fn = fn.toString();
    answer = {};
    answer.func = utils.toBase64(fn);
    answer.args = args;
    answer = JSON.stringify(answer);
    return ";(\'" + answer + "\');";
  };

  Master.prototype._unwrapResult = function(res) {
    var data;
    data = eval(res);
    data = JSON.parse(data);
    if (data.type === "function") {
      return eval(";(" + (utils.fromBase64(data.result)) + ");");
    } else {
      return data.result;
    }
  };

  Master.prototype.start = function(fn, args) {
    var p, worker;
    if (args == null) {
      args = [];
    }
    p = utils.defer();
    worker = cp.fork(__dirname + "/worker", [], {
      silent: true
    });
    worker.stdout.pipe(process.stdout);
    worker.on("message", (function(_this) {
      return function(msg) {
        worker.kill();
        return p.resolve(_this._unwrapResult(msg));
      };
    })(this));

    /**
     * @todo решить вопрос с невозвращающимися ошибками
     */
    worker.stderr.on("data", (function(_this) {
      return function(data) {
        worker.kill();
        return p.reject(new Error(data));
      };
    })(this));
    worker.send(this._wrapFunction(fn, args));
    return p.promise;
  };

  return Master;

})();

master = new Master();

module.exports = master.start;
