"use strict"
cp          = require 'child_process'

Promise     = require 'bluebird'
_           = require 'lodash'

utils       = require './utils'

###*
 * @todo Решить вопрос с ошибками в сопрограммах
###

class Master
    constructor: ->
        @workers = []

        @options = {
            cmd: "node"
        }

    _wrapFunction: (fn, args = [])=>
        fn = fn.toString()

        answer = {}
        answer.func = utils.toBase64 fn
        answer.args = args

        answer = JSON.stringify(answer)
        ";(\'#{answer}\');"

    _unwrapResult: (res)=>
        data = eval res
        data = JSON.parse(data)

        if data.type is "function"
            return eval ";(#{utils.fromBase64(data.result)});"
        else
            return data.result

    start: (fn, args = [])=>
        p = utils.defer()

        worker = cp.fork("#{__dirname}/worker", [], {
            silent: true
        })

        # Reverse std streams
        worker.stdout.pipe process.stdout
        # worker.stderr.pipe process.stderr

        worker.on "message", (msg)=>
            worker.kill()
            p.resolve @._unwrapResult(msg)

        ###*
         * @todo решить вопрос с невозвращающимися ошибками
        ###
        # worker.on error, (error)=>
        worker.stderr.on "data", (data)=>
            worker.kill()
            p.reject(new Error(data))

        worker.send @._wrapFunction(fn, args)

        return p.promise

master = new Master()
module.exports = master.start
