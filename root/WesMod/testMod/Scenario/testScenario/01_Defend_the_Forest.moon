
AOI_TRACK = ->

part = ->

STARTING_VILLAGES = ->
    return nil

SCATTER_IMAGE = ->
    return nil

---
NEW_GOLD_CARRYOVER = (PERCENTAGE_NUMBER, cfg) ->
    with cfg
        .carryover_add = true
        .carryover_percentage = PERCENTAGE_NUMBER
    return cfg
---
HINT = (MESSAGE, cfg) ->
    with cfg
        .notes_string = [[Hint:]]
        .note =
            description: MESSAGE
    return cfg
---
-- Enable the specified flag variant: knalgan, loyalist, ragged,
-- long, undead, or wood-elvish. Use within a [side] block; only
-- affects that side.
-- Since the ragged variant has six frames instead of the usual four,
-- for that flag it's better to use FLAG_VARIANT6 below instead.
FLAG_VARIANT = (NAME, cfg) ->
    with cfg
        .flag = "flags/#{NAME}-flag-[1~4]:150"
        .flag_icon = "flags/#{NAME}-flag-icon"
    return cfg
---
-- Like FLAG_VARIANT, but this supports flags with six frames.
-- Currently only the ragged flag has six frames.
FLAG_VARIANT6 = (NAME, cfg) ->
    with cfg
        .flag = "flags/#{NAME}-flag-[1~6]:150"
        .flag_icon = "flags/#{NAME}-flag-icon"
    return cfg
---
-- Creates a unit with the Loyal trait.
--
-- Example:
-- NAMED_LOYAL_UNIT 1 "Elvish Fighter" 19 16 "Myname" _("Myname")
--
NAMED_LOYAL_UNIT = (SIDE, TYPE, X, Y, ID_STRING, NAME_STRING, cfg) ->
    with cfg
        .side = SIDE
        .type = TYPE
        .id = ID_STRING
        .name = NAME_STRING
        .x = X
        .y = Y
        .modifications = { TRAIT_LOYAL }
        .overlays = "misc/loyal-icon"
    return cfg
---
CHARACTER_STATS_ERLORNAS = (cfg) ->
    with cfg
        .type = "Elvish Archer"
        .id = "Erlornas"
        .name = [[Erlornas]]
        .profile = "portraits/erlornas"
        .can_recruit = true
        .unrenamable = true
    return cfg
---
AOI_BIGMAP = (cfg) ->
    with cfg
        .background =
            image: "maps/background"
            scale_vertically: true
            scale_horizontally: false
            keep_aspect_ratio: true
        .map =
            image: "maps/aoi"
            scale_vertically: true
            scale_horizontally: false
            keep_aspect_ratio: true
            base_layer: true
    return cfg
---
-- DAWN =
--     id: "dawn"
--     name: [[Dawn]]
--     image: "misc/time-schedules/default/schedule-dawn"
--     red: -20
--     green: -20
--     sound: "ambient/morning"
-- ---
-- MORNING =
--     id: "morning"
--     name: [[Morning]]
--     image: "misc/time-schedules/default/schedule-morning"
--     lawful_bonus: 25
-- ---
-- MIDDAY =
--     id: "midday"
--     name: [[Midday]]
--     image: "misc/time-schedules/tod-schedule-24hrs~CROP(0,39,125,39)"
--     lawful_bonus: 25
-- ---
-- AFTERNOON =
--     id: "afternoon"
--     name: [[Afternoon]]
--     image: "misc/time-schedules/default/schedule-afternoon"
--     lawful_bonus: 25
-- ---
-- DUSK =
--     id: "dusk"
--     name: [[Dusk]]
--     image: "misc/time-schedules/default/schedule-dusk"
--     green: -20
--     blue: -20
--     sound: "ambient/night"
-- ---
-- FIRST_WATCH =
--     id: "first_watch"
--     name: [[First Watch]]
--     image: "misc/time-schedules/default/schedule-firstwatch"
--     lawful_bonus: -25
--     red: -45
--     green: -35
--     blue: -10
-- ---
-- SECOND_WATCH =
--     id: "second_watch"
--     name: [[Second Watch]]
--     image: "misc/time-schedules/default/schedule-secondwatch"
--     lawful_bonus: -25
--     red: -45
--     green: -35
--     blue: -10
-- ---
-- DEFAULT_SCHEDULE = {
--     DAWN
--     MORNING
--     AFTERNOON
--     DUSK
--     FIRST_WATCH
--     SECOND_WATCH
-- }
---
-- Macro to define a 'quantity' differently based on difficulty levels.
-- @TODO need some explanation here
QUANTITY = (EASY_VALUE, NORMAL_VALUE, HARD_VALUE) ->
    return ->
        if EASY
            return EASY_VALUE
        if NORMAL
            return NORMAL_VALUE
        if HARD
            return HARD_VALUE
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
scenario
    id: "test"
    name: [[Defend the Forest]]

    map: "test_map"
    turns: 24
    next_scenario: "02_Assassins"

    time: DEFAULT_SCHEDULE
    playlist: {"knolls", "wanderer", "sad"}

    Prestart: ->
        part AOI_BIGMAP
            music: "elvish-theme"
            story: [[The arrival of humans and orcs caused turmoil among the nations of the Great Continent. Elves, previously in uneasy balance with dwarves and others, had for centuries fought nothing more than an occasional skirmish. They were to find themselves facing conflicts of a long-forgotten intensity.]]
        part AOI_BIGMAP
            story: [[Their first encounter with the newcomers went less well than either side might have wished.]]
        part AOI_BIGMAP
            story: [[But humans, though crude and brash, at least had in them a creative spark which elves could recognize as akin to their own nature. Orcs seemed completely alien.]]
        part AOI_BIGMAP
            story: [[For some years after Haldric’s people landed, orcs remained scarce more than a rumor to trouble the green fastnesses of the elves. That remained so until the day that an elvish noble of ancient line, Erlornas by name, faced an enemy unlike any he had ever met before.]]
        part AOI_BIGMAP
            --po: "northern marches" is *not* a typo for "northern marshes" here.
            --po: In archaic English, "march" means "border country".
            story: [[The orcs were first sighted from the north marches of the great forest of Wesmere.]]
        AOI_TRACK(JOURNEY_01_NEW)

    side: FLAG_VARIANT "wood-elvish"
        side: 1
        controller: "human"
        recruit: {"Elvish Archer", "Elvish Fighter", "Elvish Scout", "Elvish Shaman"}
        gold: QUANTITY 200, 150, 100
        income: 0
        team_id: "good"
        team_name: [[Elves]]
        unit: CHARACTER_STATS_ERLORNAS
            facing: "nw"
        unit: NAMED_LOYAL_UNIT 1, "Elvish Archer",
            15, 18,
            "Lomarfel", [[Lomarfel]]
                facing: "ne"
                profile: "portraits/lomarfel"

    side: FLAG_VARIANT6 "ragged"
        side: 2
        controller: "ai"
        recruit: {"Orcish Archer", "Orcish Grunt", "Wolf Rider"}
        gold: QUANTITY 100, 125, 150
        income: 0
        team_id: "Orcs"
        team_name: [[Orcs]]
        unit:
            type: "Elvish Archer" --type: "Orcish Warrior"
            id: "Urugha"
            name: [[Urugha]]
            can_recruit: true
            facing: "se"
        ai:
            grouping: "offensive"
            attack_depth: 5

    Prestart: ->
        STARTING_VILLAGES 1, 6
        SCATTER_IMAGE "terrain=Re", 1, "scenery/rubble"
        obj =
            objective:
                description: [[Defeat Urugha]]
                condition: "win"
            objective:
                description: [[Death of Erlornas]]
                condition: "lose"
            objective: TURNS_RUN_OUT
            gold_carryover:
                bonus: true
                carryover_percentage: 40
        if EASY
            HINT [[Elves can move quickly and safely among the trees. Pick off the enemy grunts with your archers from the safety of the forest.]], obj
        objectives obj

    Start: ->

        local_heil = "mega_heil"
        export heil_fabimir = "heil_fabimir"

        message
            speaker: "Lomarfel"
            message: [[My lord! A party of aliens has made camp to the north and lays waste to the forest. Our scouts believe it’s a band of orcs.]]
        message
            speaker: "Erlornas"
            message: [[Orcs? It seems unlikely. The human king, Haldric, crushed them when they landed on these shores, and since then they’ve been no more than a bogey mothers use to scare the children.]]
        message
            speaker: "Lomarfel"
            message: [[So it seemed, my lord. Yet there is a band of them in the north cutting down healthy trees by the dozen, and making great fires from the wood. They trample the greensward into mud and do not even bury their foul dung. I believe I can smell the stench even here.]]
        message
            speaker: "Erlornas"
            message: [[So the grim tales of them prove true. They must not be allowed to continue; we must banish this blight from our forests. I shall marshal the wardens and drive them off. And the Council needs to hear of this; take the message and return with reinforcements, there might be more of them.]]
        message
            speaker: "Lomarfel"
            message: [[Yes, my lord!]]
        kill
            id: "Lomarfel"
        move_unit_fake
            type: "Elvish Rider"
            x: {15,14,14,13,12,11,10}
            y: {18,18,19,20,20,20,20}
        -- this is an example of a nested event
        -- event
        --     event: "Turn2"
        --     command: ->
        --         message
        --             speaker: "Erlornas"
        --             message: [[Look at them. Big, slow, clumsy and hardly a bow in hand. Keep to the trees, use your arrows and the day will be ours.]]

    TimeOver: ->
        message
            race: "elf"
            message: [[It’s hopeless; we’ve tried everything, and they’re still coming back.]]
        message
            speaker: "Urugha"
            message: [[Forward, you worthless worms! Look at them, they’re tired and afraid! You killed their will to fight, now go and finish the job!]]
        message
            speaker: "Erlornas"
            message: [[That cloud of dust on the horizon... flee! There’s more of the abominations heading this way! Fall back before we’re outnumbered and crushed.]]
        message
            speaker: "narrator"
            image: "wesnoth-icon"
            message: [[Lord Erlornas didn’t drive the orcs back, although he and his warriors tried their absolute best. When another war band arrived, elvish resistance crumbled.]]
        message
            speaker: "narrator"
            image: "wesnoth-icon"
            message: [[Of the ensuing events little is known, since much was lost in the chaos and confusion, but one thing is painfully sure. Elves lost the campaign.]]

    LastBreath:
        filter:
            id: "Erlornas"
        command: ->
            message
                speaker: "Erlornas"
                message: [[Ugh...]]
            message
                speaker: "Urugha"
                message: [[Finally! Got him!]]
            message
                race: "elf"
                not:
                    id: "Erlornas"
                message: [[Lord!]]
            message
                speaker: "Erlornas"
                message: [[Take... command... Drive them... away.]]
            message
                speaker: "narrator"
                image: "wesnoth-icon"
                message: [[Lord Erlornas died the day he first fought the orcs and never saw the end of the war. Given its final outcome, this was perhaps for the best.]]

    LastBreath:
        filter:
            id: "Urugha"
        command: ->
            message
                speaker: "unit"
                message: [[I’ve been bested, but the combat wasn’t fair... A thousand curses on you, withered coward! May you suffer... and when my master, Rualsha, finds you may he wipe your people from the face of this earth!]]

    Die:
        filter:
            id: "Urugha"
        command: ->
            message
                speaker: "Erlornas"
                message: [[Rualsha? Hmm... What if... Assemble a war-party, we need to scout north!]]
            endlevel NEW_GOLD_CARRYOVER 40
                result: "victory"
                bonus: true
