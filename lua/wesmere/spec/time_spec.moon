require "moonscript"

time = require("time")

describe "time", ->

    state =
        area: {}

    describe "add_time_area", ->

        it "'dark forest'", ->

            time.add_time_area(state, {
                x: {"1-2","4-5"}
                y: {"1-2","1-2"}
                id: "dark forest"
            })

    describe "remove_time_area", ->




    describe "get_time_of_day", ->
