ack    = require('../../../ack')

ack (name)->
    switch name
        when "Rincewind"
            return "wizzard"
        when "Twoflower"
            return "tourist"
        when "The Luggage"
            return "chest"
        else
            return "oops"