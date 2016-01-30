"use strict"
assert      = require 'assert'

octarine    = require '../master'

describe "octarine(fn)", ->
    it "should returns number", ->
        @.slow(1000)

        coroutine = -> 1983

        octarine(coroutine)
        .then (res)->
            assert.equal(res, 1983)

    it "should returns string", ->
        @.slow(1000)

        coroutine = -> "The Colour of Magic"

        octarine(coroutine)
        .then (res)->
            assert.equal(res, "The Colour of Magic")

    it "should returns array", ->
        @.slow(1000)

        coroutine = -> [
                "Rincewind"
                "Twoflower"
                "The Luggage"
            ]

        octarine(coroutine)
        .then (res)->
            assert.deepEqual(res, [
                "Rincewind"
                "Twoflower"
                "The Luggage"
            ])

    it "should returns object", ->
        @.slow(1000)

        coroutine = -> {
                "wizzard": "Rincewind"
                "tourist": "Twoflower"
                "chest": "The Luggage"
            }

        octarine(coroutine)
        .then (res)->
            assert.deepEqual(res, {
                "wizzard": "Rincewind"
                "tourist": "Twoflower"
                "chest": "The Luggage"
            })

    it "should returns function", ->
        @.slow(1000)

        coroutine = ->
            (name)->
                switch name
                    when "Rincewind"
                        return "wizzard"
                    when "Twoflower"
                        return "tourist"
                    when "The Luggage"
                        return "chest"
                    else
                        return "oops"

        octarine(coroutine)
        .then (res)->
            assert.equal res("Rincewind"), "wizzard"
            assert.equal res("Twoflower"), "tourist"
            assert.equal res("The Luggage"), "chest"
            assert.equal res("???"), "oops"

describe "octarine(fn, attr)", ->
    it "should returns number", ->
        @.slow(1000)

        coroutine = (year)-> year

        octarine(coroutine, [1983])
        .then (res)->
            assert.equal(res, 1983)

    it "should returns string", ->
        @.slow(1000)

        coroutine = ->
            args = [].slice.call(arguments, 0)
            args.join(" ")

        octarine(coroutine, ["The", "Colour", "of", "Magic"])
        .then (res)->
            assert.equal(res, "The Colour of Magic")

    it "should returns array", ->
        @.slow(1000)

        coroutine = (id)->
            items = [
                "Rincewind"
                "Twoflower"
                "The Luggage"
            ]

            return [ items[id] ]

        octarine(coroutine, [1])
        .then (res)->
            assert.deepEqual(res, ["Twoflower"])

    it "should returns object", ->
        @.slow(1000)

        coroutine = (role)->
            items = {
                "wizzard": "Rincewind"
                "tourist": "Twoflower"
                "chest": "The Luggage"
            }

            item = items[role]

            return {
                "#{role}": item
            }

        octarine(coroutine, ["wizzard"])
        .then (res)->
            assert.deepEqual(res, {
                "wizzard": "Rincewind"
            })

    ###*
     * @todo  настроить возврат функции
    ###
    # it "should returns function", ->
    #     @.slow(1000)

    #     coroutine = (name)->
    #         switch name
    #             when "Rincewind"
    #                 role = "wizzard"
    #             when "Twoflower"
    #                 role = "tourist"
    #             when "The Luggage"
    #                 role = "chest"
    #             else
    #                 role = "oops"

    #         (toUpperCase = false)->
    #             if toUpperCase then role.toUpperCase() else role

    #     octarine(coroutine, ['Rincewind'])
    #     .then (res)->
    #         assert.equal res(false), "Rincewind"

describe "octarine(path)", ->
    it "should returns number - absolute path", ->
        @.slow(1000)

        octarine("#{__dirname}/helps/coroutine_number")
        .then (res)->
            assert.equal(res, 1983)
    it "should returns number - relative path", ->
        @.slow(1000)

        octarine("./helps/coroutine_number")
        .then (res)->
            assert.equal(res, 1983)


    it "should returns string - absolute path", ->
        @.slow(1000)

        octarine("#{__dirname}/helps/coroutine_string")
        .then (res)->
            assert.equal(res, "The Colour of Magic")
    it "should returns string - relative path", ->
        @.slow(1000)

        octarine("./helps/coroutine_string")
        .then (res)->
            assert.equal(res, "The Colour of Magic")


    it "should returns array - absolute path", ->
        @.slow(1000)

        octarine("#{__dirname}/helps/coroutine_array")
        .then (res)->
            assert.deepEqual(res, [
                "Rincewind"
                "Twoflower"
                "The Luggage"
            ])
    it "should returns array - relative path", ->
        @.slow(1000)

        octarine("./helps/coroutine_array")
        .then (res)->
            assert.deepEqual(res, [
                "Rincewind"
                "Twoflower"
                "The Luggage"
            ])


    it "should returns object - absolute path", ->
        @.slow(1000)

        octarine("#{__dirname}/helps/coroutine_object")
        .then (res)->
            assert.deepEqual(res, {
                "wizzard": "Rincewind"
                "tourist": "Twoflower"
                "chest": "The Luggage"
            })
    it "should returns object - relative path", ->
        @.slow(1000)

        octarine("./helps/coroutine_object")
        .then (res)->
            assert.deepEqual(res, {
                "wizzard": "Rincewind"
                "tourist": "Twoflower"
                "chest": "The Luggage"
            })


    it "should returns function - absolute path", ->
        @.slow(1000)

        octarine("#{__dirname}/helps/coroutine_function")
        .then (res)->
            assert.equal res("Rincewind"), "wizzard"
            assert.equal res("Twoflower"), "tourist"
            assert.equal res("The Luggage"), "chest"
            assert.equal res("???"), "oops"
    it "should returns function - relative path", ->
        @.slow(1000)

        octarine("./helps/coroutine_function")
        .then (res)->
            assert.equal res("Rincewind"), "wizzard"
            assert.equal res("Twoflower"), "tourist"
            assert.equal res("The Luggage"), "chest"
            assert.equal res("???"), "oops"
