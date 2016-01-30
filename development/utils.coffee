"use strict"
Promise     = require 'bluebird'

###*
 * Create deferred
 * @return {Object}
###
module.exports.defer = ->
    resolve = undefined
    reject  = undefined

    promise = new Promise (args...)->
        resolve     = args[0]
        reject      = args[1]

    return {
        resolve:    resolve
        reject:     reject
        promise:    promise
    }

###*
 * Convert from 'utf8' to 'base64'
 * @param  {String} data
 * 
 * @return {String}
###
module.exports.toBase64 = (data)->
    new Buffer(data, 'utf8').toString('base64')

###*
 * Convert from 'base64' to 'utf8'
 * @param  {String} data
 * 
 * @return {String}
###
module.exports.fromBase64 = (data)->
    new Buffer(data, 'base64').toString('utf8')