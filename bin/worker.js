"use strict";
var Promise, Worker, _, utils, worker,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Promise = require('bluebird');

_ = require('lodash');

utils = require('./utils');

Worker = (function() {
  function Worker() {
    this.ack = bind(this.ack, this);
    this.start = bind(this.start, this);
    this._wrapResult = bind(this._wrapResult, this);
    this._unwrapFunction = bind(this._unwrapFunction, this);
  }


  /**
   * Десериализует функцию.
   * Функция приходят в формате:
   * ";({
   *   func - Base64
   *   args - Any[]
   * });"
   *
   * Возвращает:
   * {
   *   func
   *   args
   * }
   * 
   * @param  {String} fn
   * 
   * @return {Object}
   */

  Worker.prototype._unwrapFunction = function(fn) {
    var args, data, func;
    data = eval(fn);
    data = JSON.parse(data);
    func = eval(";(" + (utils.fromBase64(data.func)) + ");");
    args = data.args;
    return {
      func: func,
      args: args
    };
  };


  /**
   * Сериализует результат.
   * Результат возвращается в формате Ж
   * ";({
   *   result - Any/Base64 если это функция
   *   type   - String
   * });"
   * 
   * @param  {Any} res [description]
   * @return {[type]}     [description]
   */

  Worker.prototype._wrapResult = function(res) {
    var answer;
    answer = {};
    if (_.isFunction(res)) {
      answer.result = utils.toBase64(res.toString());
      answer.type = "function";
    } else {
      answer.result = res;
      answer.type = typeof res;
    }
    answer = JSON.stringify(answer);
    return ";(\'" + answer + "\');";
  };


  /**
   * Начитает слущать сообщения
   */

  Worker.prototype.start = function() {
    return process.on("message", (function(_this) {
      return function(msg) {
        var data, result;
        data = _this._unwrapFunction(msg);
        switch (false) {
          case !_.isFunction(data.func):
            result = data.func.apply(data, data.args);
            break;
          default:
            result = data.func;
        }
        return Promise.resolve(result).then(function(res) {
          return _this.ack(res);
        }, function(err) {
          throw err;
        });
      };
    })(this));
  };


  /**
   * Отвечает родительскому процессу
   * @param  {String} res
   */

  Worker.prototype.ack = function(res) {
    return _.once(process.send(this._wrapResult(res)));
  };

  return Worker;

})();

worker = new Worker();

if (!module.parent) {
  worker.start();
} else {

  /**
   * Отправка ответа
   * @type {Function}
   */
  module.exports = worker.ack;
}
