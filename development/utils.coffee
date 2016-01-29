"use strict"

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

module.exports.toBase64 = (data)->
    new Buffer(data, 'utf8').toString('base64')

module.exports.fromBase64 = (data)->
    new Buffer(data, 'base64').toString('utf8')