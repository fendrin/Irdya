---
-- @submodule wesmere

-- LuaWML:Units
-- This page describes the LuaWML functions for handling units.

---
-- A unit is a proxy table with the following fields:
-- @table unit
--


-- x, y: integers (read only, read/write if the unit is not on the map)
-- side: integer (read/write)
-- id: string (read only)
-- type: string (read only)
-- name: translatable string (read only)
-- max_hitpoints, experience, max_experience, max_moves: integers (read only)
-- max_attacks: integer (read only)
-- attacks_left: integer (read/write) Setting below 0 is limited to 0.
-- extra_recruit: table (read/write)
-- advances_to: table (read/write)
-- hitpoints, experience: integer (read/write)
-- moves: integer (read/write)
-- level: (Version 1.13.2 and later only) integer (read only)
-- resting: boolean (read/write)
-- hidden: boolean (read/write)
-- petrified, canrecruit: booleans (read only)
-- role, facing: strings (read/write)
-- status: proxy associative table (read only, read/write fields)
-- image_mods: string (read only)
-- variables: proxy associative table (read only, read/write fields, including variables.__cfg), only toplevel named fields are proxied
-- attacks: (Version 1.13.0 and later only)an object to access the units attacks, you can use the attacks index or the attacks name to index an attack. every attack has the following members:
-- description: translatable string (read/write)
-- name: string (read)
-- type: string (read/write)
-- range: string (read/write)
-- damage: number(read/write)
-- number: number(read/write)
-- movement_used: number(read/write)
-- attack_weight: number(read/write)
-- defense_weight: number(read/write)
-- specials wml table(read/write)
-- valid: string or nil (read only)
-- advancements: (Version 1.13.2 and later only) an array of wml tables (read/write)
-- __cfg: WML table (dump)
-- (Version 1.13.2 and later only) The following fields are unit methods synonymous to one of the functions described on this page:
-- matches
-- to_recall
-- to_map
-- erase
-- clone
-- extract
-- advance
-- add_modification
-- resistance
-- defense
-- movement
-- vision
-- jamming
-- ability
-- transform
-- The metatable of these proxy tables appears as "unit".
-- A unit can be either visible on the map (#wesmere.get_units, #wesmere.put_unit), or on a recall list (#wesmere.get_recall_units, #wesmere.put_recall_unit), or private to the Lua code (#wesmere.create_unit, #wesmere.copy_unit, #wesmere.extract_unit). The Lua code has complete control over the private units; they will not be modified unless accessed through the proxy unit. Units on the map and on the recall lists, however, can be modified by the user, the engine, WML, independently of the Lua code. In particular, if a unit is killed, any further use of the proxy unit will cause an error. For units on the map, the proxy unit is valid as long as there is a unit on the map that has the same "underlying_id" WML field as the original one. The behavior is similar for units on the recall lists. The valid field reflects the unit availability by returning "map", "recall", "private", or nil. The latter value is used for units that were removed (e.g. killed). In that case, the valid field is the only one that can be read without causing an error.
-- The term "proxy", here in particular "proxy unit", means that the variable retrieved in the lua code (with get_units for example) is an accessor (reference) to the C++ object which represents that unit. This is very different from unit variables obtained by [store_unit] in wml. The fields marked as "writable" above can be modified without the need to use put_unit afterwards. This same reason explains that modifications to the unit from outside the lua code (like [kill] invalidating the proxy unit) have immediate effect on the lua code's proxy unit variable (with the exception of private proxy units).

-- Contents [hide]
-- 1 wesmere.get_units
-- 2 wesmere.get_unit
-- 3 wesmere.match_unit
-- 4 wesmere.put_unit
-- 5 wesmere.erase_unit
-- 6 wesmere.get_recall_units
-- 7 wesmere.put_recall_unit
-- 8 wesmere.create_unit
-- 9 wesmere.copy_unit
-- 10 wesmere.extract_unit
-- 11 wesmere.advance_unit
-- 12 wesmere.add_modification
-- 13 wesmere.unit_resistance
-- 14 wesmere.unit_defense
-- 15 wesmere.unit_movement_cost
-- 16 wesmere.unit_vision_cost
-- 17 wesmere.unit_jamming_cost
-- 18 wesmere.unit_ability
-- 19 wesmere.unit_types
-- 20 wesmere.races
-- 21 wesmere.get_traits
-- 22 wesmere.simulate_combat
-- 23 wesmere.transform_unit

----
-- Returns an array of all the units on the map matching the WML filter passed as the first argument.
-- @function wesmere.get_units
-- @tparam StandardUnitFilter filter
-- @usage leaders_on_side_two = get_units { side: 2, can_recruit: true }
-- name_of_leader = leaders_on_side_two[1].name
wesmere.get_units = (filter) ->

----
-- Returns the unit at the given location
-- @function wesmere.get_unit
-- @number x
-- @number y
-- @treturn Unit at the location
-- @usage args = ...
-- unit = wesmere.get_unit(args.x1, args.y1)

----
-- Returns the unit with the given underlying ID.
-- @function wesmere.get_unit
-- @number underlying_id
-- @treturn Unit with the underlying_id
wesmere.get_unit = (x, y) ->

----
-- Returns true if the given unit matches the WML filter passed as the second argument. If other_unit is specified, it is used for the $other_unit auto-stored variable in the filter. Otherwise, this variable is not stored for the filter.
-- @function wesmere.match_unit
-- @tparam Unit unit
-- @tparam StandardUnitFilter filter
-- @tparam[opt] Unit other_unit
-- @usage assert(unit.can_recruit == wesmere.match_unit(unit, { can_recruit: true }))
wesmere.match_unit = (unit, filter, other_unit) ->
    return unit\match(filter, other_unit)

----
-- Erases a unit from the map. After calling this on a unit, the unit is no longer valid.
-- @function wesmere.erase_unit
-- @tparam Unit unit

----
-- Erases a unit from the map. After calling this on a unit, the unit is no longer valid.
-- @function wesmere.erase_unit
-- @see Unit:erase
wesmere.erase_unit = (x, y) ->
    u = wesmere.get_unit(x, y)
    return u\erase!

----
-- Returns an array of all the units on the recall lists matching the WML filter passed as the first argument.
-- @function wesmere.get_recall_units
-- @tparam StandardUnitFilter filter
-- @treturn {Unit,...}
wesmere.get_recall_units = (filter) ->

----
-- Places a unit on a recall list. This unit is described either by a WML table or by a proxy unit. The side of the recall list is given by the second argument, or by the side of the unit if missing.
-- When the argument is a proxy unit, no duplicate is created. In particular, if the unit was private or on the map, it no longer is. Note: passing a WML table is just a shortcut for calling #wesmere.create_unit and then putting the resulting unit on a recall list.
-- @function wesmere.put_recall_unit
-- @tparam Unit unit
-- @number[opt] side
-- @usage -- put the unit at location 17,42 on the recall list for side 2
-- wesmere.put_recall_unit(wesmere.get_units({ x: 17, y: 42 })[1], 2)
wesmere.put_recall_unit = (unit, [side]) ->
    if moon.type(unit) != Unit
      u = Unit(unit)
      u\to_recall(side)
    else unit\to_recall(side)

----
-- Creates a private unit from a WML table.
-- @function wesmere.create_unit
-- @tparam unit_table unit_info
-- @usage u = wesmere.create_unit { type: "White Mage", gender: "female" }
wesmere.create_unit = (unit_info) ->

----
-- Creates a private unit from another unit.
-- @function wesmere.copy_unit
-- @see Unit:clone
-- @usage -- extract a unit from the map
-- u = wesmere.copy_unit(wesmere.get_units({ type: "Thug" })[1])
-- wesmere.put_unit(u.x, u.y)
-- -- u is still valid at this point
wesmere.copy_unit = (unit) ->
    return unit\clone!



----
-- Removes a unit from the map or from a recall list and makes it private.
-- @function wesmere.extract_unit
-- @see Unit:extract
-- @usage -- remove all the units from the recall list of side 1 and put them in a WML container
-- l = {}
-- for u in *wesmere.get_recall_units { side: 1 })
--     wesmere.extract_unit(u)
--     table.insert(l, u.__cfg)
-- helper.set_variable_array("player_recall_list", l)
-- Note: if the unit is on the map, it is just a shortcut for calling #wesmere.copy_unit and then #wesmere.put_unit without a unit. It is, however, the only way for removing a unit from a recall list without putting it on the map.
wesmere.extract_unit = (unit) ->
    unit\extract!

----
-- Advances the unit (and shows the advance unit dialog if needed) if the unit has enough xp. This function should be called after modifying the units experience directly. A similar function is called by wesmere internally after unit combat.
-- This function only works for units on the map.
-- This function can also trigger multiple advancements if the unit has enough xp.
-- @function wesmere.advance_unit
-- @tparam Unit unit
-- @bool animate specifies whether the advancement should be animated.
-- @bool fire_events specifies whether advancement related events should be fired.
wesmere.advance_unit = (unit, animate, fire_events) ->
    unit\advance(animate, fire_events)

----
-- Modifies a given unit.
-- @function wesmere.add_modification
-- @tparam Unit It needs to be a proxy unit.
-- @string type of the modification (one of "trait", "object", or "advancement"). The option "advance" applies effects as if the unit would advance (e.g. AMLA effects).
-- describing the effect, so mostly containing [effect] children. See EffectWML for details about effects.
-- @bool[opt] write_to_mods if false, causes it to not write the modification tag to the unit's [modifications] (as would be done with an [object] with no_write=true).
-- @see Unit:add_modification
-- @usage u = wesmere.get_units { canrecruit = true }[1]
-- wesmere.add_modification(u, "object", { { "effect", { apply_to: "image_mod", replace: "RC(red>blue)" } } })
wesmere.add_modification = (unit, type, effects, write_to_mods) ->
    unit\add_modification(type, effects, write_to_mods)

----
-- Returns the resistance of a unit against an attack type. (Note: it is a WML resistance. So the higher it is, the weaker the unit is.)
-- @function wesmere.unit_resistance
-- @bool whether the unit is the attacker.
-- @tparam[opt] Location loc coordinates of an optional map location (for the purpose of taking abilities into account).
-- @see Unit:resistance
-- @usage fire_resistance = 100 - wesmere.unit_resistance(u, "fire")
wesmere.unit_resistance = (unit, damage_type) ->
    return unit\resistance(damage_type)

----
-- Returns the defense of a unit on a particular terrain. (Note: it is a WML defense. So the higher it is, the weaker the unit is.)
-- @function wesmere.unit_defense
-- @see Unit:defense
-- @usage flat_defense = 100 - wesmere.unit_defense(u, "Gt")
wesmere.unit_defense = (unit, terrain_code) ->
    return unit\defense(terrain_code)

----
-- Returns the movement cost of a unit on a particular terrain.
-- @function wesmere.unit_movement_cost
-- @usage move_cost = wesmere.unit_movement_cost(u, "Gt")
-- @see Unit:movement
wesmere.unit_movement_cost = (unit, terrain_code) ->
    unit\movement(terrain_code)

----
-- Returns the vision cost of a unit on a particular terrain.
-- @function wesmere.unit_vision_cost
-- @see Unit:vision
-- @usage see_cost = wesmere.unit_vision_cost(u, "Gt")
wesmere.unit_vision_cost = (unit, terrain_code) ->
    return unit\vision(terrain_code)

----
-- Returns the jamming cost of a unit on a particular terrain.
-- @function wesmere.unit_jamming_cost
-- @see Unit:jamming
-- @usage jam_cost = wesmere.unit_jamming_cost(u, "Gt")
wesmere.unit_jamming_cost = (unit, terrain_code) ->
    return unit\jamming(terrain_code)

----
-- Returns true if the unit is currently under effect by an ability with this given TAG NAME. This means that the ability could be owned by the unit itself, or by an adjacent unit.
-- @function wesmere.unit_ability
-- @see Unit:ability
-- @usage has_teleport = (u) ->
--     return wesmere.unit_ability(u, "teleport")
wesmere.unit_ability = (unit, ability_tag) ->
    return unit\ability(ability_tag)

----
-- This is not a function but a table indexed by unit type ids. Its elements are proxy tables with these fields:
-- @table wesmere.unit_types
-- @string id
-- name: translatable string (read only)
-- max_moves, max_experience, max_hitpoints, level, cost: integers (read only)
-- __cfg: WML table (dump)
-- The metatable of these proxy tables appears as "unit type".
-- local lich_cost = wesmere.unit_types["Ancient Lich"].cost

----
-- This is not a function but a table indexed by race ids. Its elements are proxy tables for all races the engine knows about. known fields of each element:
-- @table wesmere.races
-- @string id string
-- @tparam tstring description
-- @tparam tstring name
-- @tparam tstring plural_name (translatable strings)
-- @number num_traits (integer)
-- @bool ignore_global_traits (boolean)
-- @string undead_variation (string)
-- (all read only)
-- __cfg: WML table (dump)
-- @usage wesmere.message(tostring(wesmere.races["lizard"].name))

----
-- Returns a table with named fields (trait id strings) holding the wml tables defining the traits. arguments: none. All global traits the engine knows about, race-specific traits are not included. Known fields and subtags of each element are the ones which were given in the wml definition of the trait.
-- @function wesmere.get_traits
-- @usage wesmere.message(tostring(wesmere.get_traits().strong.male_name))
wesmere.get_traits = () ->

----
-- Computes the hitpoint distribution and status chance after a combat between two units. The first unit is the attacker; it does not have to be on the map, though its location should be meaningful. The second unit is the defender; it has to be on the map.
-- @function wesmere.simulate_combat
wesmere.simulate_combat = (attacker, [attacker_weapon_index], defender, [defender_weapon_index]) ->
-- Optional integers can be passed after each unit to select a particular weapon, otherwise the "best" one is selected. When giving the weapon, the parameter is the weapon number (integer, starting at 1) and not an element from the table returned by helper.child_range(att, "attack").
-- @usage display_stats = (n, t) ->
--     wesmere.message(string.format(
--         "Chance for the %s\n  to be slowed: %f,\n  to be poisoned: %f,\n  to die: %f.\nAverage HP: %f.",
--         n, t.slowed, t.poisoned, t.hp_chance[0], t.average_hp))
-- local att_stats, def_stats = wesmere.simulate_combat(att, att_weapon, def, def_weapon)
-- display_stats("attacker", att_stats)
-- display_stats("defender", def_stats)
-- Returns 2 additional tables which contain information about the weapons and the effect of single hits with these keys: num_blows, damage, chance_to_hit, poisons, slows, petrifies, plagues, plague_type, backstabs, rounds, firststrike, drains, drain_constant, drain_percent, attack_num, name. Name is the wml name not the description. If there is no weapon, then name will be nil
-- @usage att_stats, def_stats, att_weapon, def_weapon = wesmere.simulate_combat(attacker, att_weapon_number, defender)
-- wesmere.message(string.format(
--     "The attack %s should be countered with %s, which does %d damage, has %d%% chance to hit and forces %d attack rounds due to its berserk ability.",
--     att_weapon.name, def_weapon.name or "no weapon", def_weapon.damage, def_weapon.chance_to_hit, def_weapon.rounds))

----
-- Changes the type of a unit and adjust attributes accordingly. Note that hit points are only changed if necessary to accommodate the new maximum hit points. Poison is automatically removed if the transformed unit is immune.
-- @function wesmere.transform_unit
-- @tparam Unit unit
-- @string to_type
-- @see Unit:transform
-- @usage ev = wesmere.current.event_context
-- u = wesmere.get_units{x=ev.x1, y=ev.y1}[1]
-- wesmere.transform_unit(u, "Spearman")
-- -- If a full heal is desired:
-- u.hitpoints = u.max_hitpoints
-- u.status.poisoned = false
wesmere.transform_unit = (unit, to_type) ->
    unit\transform(to_type)
