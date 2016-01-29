"use strict"
Promise     = require 'bluebird'
_           = require 'lodash'

utils       = require './utils'

class Worker
    constructor: ->

    _unwrapFunction: (fn)=>
        data = eval fn
        data = JSON.parse(data)

        func = eval ";(#{utils.fromBase64(data.func)});"
        args = data.args

        return {
            func
            args
        }

    _wrapResult: (res)=>
        answer = {}

        if _.isFunction(res)
            answer.result = utils.toBase64 res.toString()
            answer.type = "function"
        else
            answer.result = res
            answer.type = typeof res
        
        answer = JSON.stringify(answer)
        ";(\'#{answer}\');"

    start: =>
        process.on "message", (msg)=>
            data = @._unwrapFunction(msg)

            switch
                when _.isFunction(data.func)
                    result = data.func(data.args...)
                else
                    result = data.func

            Promise.resolve(result)
            .then (res)=>
                @.ack(res)
            , (err)=>
                throw err


    ack: (res)=>
        process.send @._wrapResult(res)

worker = new Worker()
worker.start()