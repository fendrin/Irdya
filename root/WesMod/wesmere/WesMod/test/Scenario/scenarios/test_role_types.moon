GENERIC_UNIT_TEST "test_role_1", ->
    event
        name: "Prestart"
        command: ->
            -- create a bunch of units in side 1 recall list
            unit UNIT 1, "Ghost", "recall", "recall", {id:"wrong_0"}
            unit UNIT 1, "Shadow", "recall", "recall", {id:"wrong_1"}
            unit UNIT 1, "Spectre", "recall", "recall", {id:"correct"}
            unit UNIT 1, "Wraith", "recall", "recall", {id:"wrong_2"}
            unit UNIT 1, "Nightgaunt", "recall", "recall", {id:"wrong_3"}

    event
        name: "Start"

        command: ->
            set_variable
                name: "roles"
                value:{"Spectre","Nightgaunt","Wraith","Shadow","Ghost"}

            role
                role:"advisor"
                side:1
                type:roles

            recall
                role:"advisor"

            ASSERT have_unit
                side:1
                role:"advisor"
                type:"Spectre"
                id:"correct"
                search_recall_list:false

            SUCCEED!


GENERIC_UNIT_TEST "test_role_2", ->
    event
        name:"Prestart"
        command: ->
            -- create a bunch of units on field for side 2
            UNIT 2, "Troll Whelp", 13, 2, {id:"wrong_0"}
            UNIT 2, "Troll", 12, 2, {id:"wrong_1"}
            UNIT 2, "Troll Shaman", 14, 2, {id:"correct"}
            UNIT 2, "Troll Warrior", 12, 3, {id:"wrong_2"}
            UNIT 2, "Troll Rocklobber", 14, 3, {id:"wrong_3"}

    event
        name: "Start"

        command: ->
            role
                role:"smart"
                side:2
                type:{"Troll Shaman","Troll Warrior","Troll Rocklobber","Troll","Troll Whelp"}

            ASSERT have_unit
                side:2
                role:"smart"
                type:"Troll Shaman"
                id:"correct"
                search_recall_list:false

            SUCCEED!

GENERIC_UNIT_TEST "test_role_3", ->
    event
        name: "Start"

        command: ->
            role
                role:"dummy"
                side:3

            ASSERT have_unit
                role:"dummy"
                count:0
                search_recall_list:true

            SUCCEED!

-- {GENERIC_UNIT_TEST "test_role_lua" (
--     [event]
--         name=start

--         {UNIT 1 "Dwarvish Thunderguard" recall recall (id=wrong_0)}
--         {UNIT 1 "Dwarvish Steelclad" recall recall (id=correct)}
--         {UNIT 1 "Dwarvish Fighter" recall recall (id=wrong_1)}
--         {UNIT 1 "Dwarvish Thunderer" recall recall (id=wrong_2)}

--         [lua]
--             code=<<
--                 local types = "Dwarvish Steelclad,Dwarvish Thunderguard,Dwarvish Fighter,Dwarvish Thunderer"

--                 wesnoth.wml_actions.role { type = types, role = "scout" }
--             >>

--         [recall]
--             role=scout


--         {ASSERT (
--             [have_unit]
--                 role=scout
--                 side=1
--                 type=Dwarvish Steelclad
--                 id=correct
--                 search_recall_list=no

--         {SUCCEED}
