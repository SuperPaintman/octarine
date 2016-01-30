"use strict"
Promise     = require 'bluebird'
_           = require 'lodash'

utils       = require './utils'

class Worker
    constructor: ->

    ###*
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
    ###
    _unwrapFunction: (fn)=>
        data = eval fn
        data = JSON.parse(data)

        func = eval ";(#{utils.fromBase64(data.func)});"
        args = data.args

        return {
            func
            args
        }

    ###*
     * Сериализует результат.
     * Результат возвращается в формате Ж
     * ";({
     *   result - Any/Base64 если это функция
     *   type   - String
     * });"
     * 
     * @param  {Any} res [description]
     * @return {[type]}     [description]
    ###
    _wrapResult: (res)=>
        answer = {}

        if _.isFunction(res)
            answer.result = utils.toBase64 res.toString()
            answer.type = "function"
        else
            answer.result = res
            answer.type = typeof res
        
        answer = JSON.stringify(answer)
        return ";(\'#{answer}\');"

    ###*
     * Начитает слущать сообщения
    ###
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

    ###*
     * Отвечает родительскому процессу
     * @param  {String} res
    ###
    ack: (res)=>
        _.once process.send @._wrapResult(res)

worker = new Worker()

if !module.parent
    worker.start()
else
    ###*
     * Отправка ответа
     * @type {Function}
    ###
    module.exports = worker.ack
