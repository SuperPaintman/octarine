"use strict";
var Promise,
  slice = [].slice;

Promise = require('bluebird');


/**
 * Create deferred
 * @return {Object}
 */

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


/**
 * Convert from 'utf8' to 'base64'
 * @param  {String} data
 * 
 * @return {String}
 */

module.exports.toBase64 = function(data) {
  return new Buffer(data, 'utf8').toString('base64');
};


/**
 * Convert from 'base64' to 'utf8'
 * @param  {String} data
 * 
 * @return {String}
 */

module.exports.fromBase64 = function(data) {
  return new Buffer(data, 'base64').toString('utf8');
};
