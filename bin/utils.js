"use strict";
var slice = [].slice;

module.exports.defer = function() {
  var promise, reject, resolve;
  resolve = void 0;
  reject = void 0;
  promise = new Promise(function() {
    var args;
    args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    resolve = args[0];
    return reject = args[1];
  });
  return {
    resolve: resolve,
    reject: reject,
    promise: promise
  };
};

module.exports.toBase64 = function(data) {
  return new Buffer(data, 'utf8').toString('base64');
};

module.exports.fromBase64 = function(data) {
  return new Buffer(data, 'base64').toString('utf8');
};
