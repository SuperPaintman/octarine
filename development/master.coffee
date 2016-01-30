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

    ###*
     * Сериализует функцию для передачи ее как сообщение.
     * Сообщение возвращается в формате 
     * ";({
     *   func - Base64
     *   args - Any[]
     * });"
     * 
     * @param  {Function} fn
     * @param  {Any[]}    [args=[]]  - аргументы, передаваемые в функцию
     * 
     * @return {String}
    ###
    _wrapFunction: (fn, args = [])=>
        fn = fn.toString()

        answer = {}
        answer.func = utils.toBase64 fn
        answer.args = args

        answer = JSON.stringify(answer)
        return ";(\'#{answer}\');"

    ###*
     * Десериализует ответ.
     * Результаты приходят в формате:
     * ";(
     *   result - Any/Base64 если это функция
     *   type   - String
     * );"
     * 
     * @param  {String} res
     * 
     * @return {Any}
    ###
    _unwrapResult: (res)=>
        data = eval res
        data = JSON.parse(data)

        if data.type is "function"
            return eval ";(#{utils.fromBase64(data.result)});"
        else
            return data.result

    ###*
     * Запускает корутину
     * @param  {Function} fn            - функция, которая будет сериализована
     * @param  {Any[]}    [args=[]]     - аргументы передаваемые в функцию
     * 
     * @return {Promise}
    ###
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
