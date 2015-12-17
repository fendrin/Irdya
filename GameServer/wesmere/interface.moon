---
-- @submodule wesmere



LuaWML:Display
This page describes the LuaWML functions and helpers for interfacing with the user.
Contents [hide]
1 wesnoth.message
2 wesnoth.clear_messages
3 wesnoth.textdomain
4 wesnoth.delay
5 wesnoth.float_label
6 wesnoth.select_hex
7 wesnoth.deselect_hex
8 wesnoth.scroll_to_tile
9 wesnoth.lock_view
10 wesnoth.view_locked
11 wesnoth.play_sound
12 wesnoth.set_music
13 wesnoth.show_message_dialog
14 wesnoth.show_popup_dialog
15 wesnoth.show_dialog
16 wesnoth.set_dialog_value
17 wesnoth.get_dialog_value
18 wesnoth.set_dialog_active
19 wesnoth.set_dialog_callback
20 wesnoth.set_dialog_markup
21 wesnoth.set_dialog_focus
22 wesnoth.set_dialog_visible
23 wesnoth.set_dialog_canvas
24 wesnoth.add_dialog_tree_node
25 wesnoth.remove_dialog_item
26 wesnoth.is_skipping_messages
27 wesnoth.skip_messages
28 wesnoth.get_displayed_unit
29 wesnoth.theme_items
30 helper.get_user_choice

---
-- @function wesnoth.message
wesnoth.message([speaker,] message)
Displays a string in the chat window and dumps it to the lua/info log domain (--log-info=scripting/lua on the command-line).
wesnoth.message "Hello World!"
The chat line header is "<Lua>" by default, but it can be changed by passing a string before the message.
wesnoth.message("Big Brother", "I'm watching you.") -- will result in "<Big Brother> I'm watching you."
See also helper.wml_error for displaying error messages.
wesnoth.clear_messages
wesnoth.clear_messages()
Removes all messages from the chat window. No argument or returned values.
wesnoth.textdomain
wesnoth.textdomain(domain)
Creates a function proxy for lazily translating strings from the given domain.
-- #textdomain "my-campaign"
-- the comment above ensures the subsequent strings will be extracted to the proper domain
_ = wesnoth.textdomain "my-campaign"
wesnoth.set_variable("my_unit.description", _ "the unit formerly known as Hero")
The metatable of the function proxy appears as "message domain". The metatable of the translatable strings (results of the proxy) appears as "translatable string".
The translatable strings can be appended to other strings/numbers with the standard .. operator. Translation can be forced with the standard tostring operator in order to get a plain string.
wesnoth.message(string.format(tostring(_ "You gain %d gold."), amount))
wesnoth.delay
wesnoth.delay(milliseconds)
Delays the engine like the [delay] tag. one argument: time to delay in milliseconds
wesnoth.delay(500)
wesnoth.float_label
wesnoth.float_label(x, y, text)
Pops some text above a map tile.
wesnoth.float_label(unit.x, unit.y, "<span color='#ff0000'>Ouch</span>")
wesnoth.select_hex
wesnoth.select_hex(x, y, [show_movement, [fire_events]])
Selects the given location in the game map as if the player would have clicked onto it. Argument 3: boolean, whether to show the movement range of any unit on that location (def: true) Argument 4: boolean, whether to fire any select events (def: false)
wesnoth.select_hex(14,6, true, true)
wesnoth.deselect_hex
wesnoth.deselect_hex()
(Version 1.13.2 and later only)
Reverses any select_hex call, leaving all locations unhighlighted. Takes no arguments.
wesnoth.scroll_to_tile
wesnoth.scroll_to_tile(x, y, [only_if_visible, [instant]])
Scrolls the map to the given location. If true is passed as the third parameter, scrolling is disabled if the tile is hidden under the fog. If true is passed as the fourth parameter, the view instantly warps to the location regardless of the scroll speed setting in Preferences.
local u = wesnoth.get_units({ id = "hero" })[1]
wesnoth.scroll_to_tile(u.x, u.y)
wesnoth.lock_view
wesnoth.lock_view(lock)
Locks or unlocks gamemap view scrolling for human players. If true is passed as the first parameter, the view is locked; pass false to unlock.
Human players cannot scroll the gamemap view as long as it is locked, but Lua or WML actions such as wesnoth.scroll_to_tile still can; the locked/unlocked state is preserved when saving the current game. This feature is generally intended to be used in cutscenes to prevent the player scrolling away from scripted actions.
wesnoth.lock_view(true)
wesnoth.scroll_to_tile(12, 14, false, true)
wesnoth.view_locked
wesnoth.view_locked()
Returns a boolean indicating whether gamemap view scrolling is currently locked.
wesnoth.play_sound
wesnoth.play_sound(sound, [repeat_count])
Plays the given sound file once, optionally repeating it one or more more times if an integer value is provided as a second argument (note that the sound is repeated the number of times specified in the second argument, i.e. a second argument of 4 will cause the sound to be played once and then repeated four more times for a total of 5 plays. See the example below).
wesnoth.play_sound "ambient/birds1.ogg"
wesnoth.play_sound("magic-holy-miss-3.ogg", 4) -- played 1 + 4 = 5 times
wesnoth.set_music
wesnoth.set_music(music_entry)
Sets the given table as an entry into the music list. See MusicListWML for the recognized attributes.
wesnoth.set_music { name = "traveling_minstrels.ogg" }
Passing no argument forces the engine to take into account all the recent changes to the music list. (Note: this is done automatically when sequences of WML commands end, so it is useful only for long events.)
wesnoth.show_message_dialog
wesnoth.show_message_dialog(attributes, [options, [text_input_attributes]])
(Version 1.13.2 and later only)
Shows a message dialog, of the type used by the [message] ActionWML tag. Unlike the [message] tag, this is unsynced; if you need it synced, you must do it yourself. The first argument is a table describing the dialog with the following keys:
title - The title to show on the message. For example, the speaker's name.
message - The message content.
portrait - An image to show along with the message. By default, no image is shown.
left_side - The default is true; set to false to show the image on the right.
mirror - If true, the image will be flipped horizontally.
The second argument is a list of options as a Lua array. Each option is either a (possibly-translatable) string or a config with DescriptionWML keys. The array itself can also have an optional default key which if present should be the index of the initially selected option (useful if you don't need full DescriptionWML but want to set a default). If present it overrides any defaults set in individual options.
The third argument is a table describing the text input field with the following keys:
label - A label to show to the left of the text field.
text - Initial contents of the text field.
max_length - Maximum input length in characters (defaults to 256).
You need at least one key for the text input to be shown. Both the second arguments are option, but if you want text input with no options, you must pass nil for the second parameter.
This function returns two values. The first is the numeric result of the dialog. If there are no options and no text input, this is -2 if the user closed by pressing Escape, otherwise it's -1. If there are options, this is the index of the option chosen (starting from 1). If there is text input but no options, the first return value is 0. If there was text input, the second value contains the text entered.
Example:
 wesnoth.show_message_dialog({
     title = "Make your choice:",
     message = "Select an option and enter some text.",
     portrait = "wesnoth-icon.png",
 }, {
     "The first choice is always the best!",
     "Pick me! Second choices are better!",
     "You know you want the third option!",
 }, {
     label = "Text:",
     text = "?",
     max_length = 16
 })
(You don't have to format it like that, of course.)
wesnoth.show_popup_dialog
wesnoth.show_popup_dialog(title, message, [image])
(Version 1.13.2 and later only)
Shows a simple popup dialog in the centre of the screen. Takes three arguments, which in order are:
A title string for the dialog
The message content for the dialog.
An image to show.
Both the title and the message support Pango markup. The image is optional.
wesnoth.show_dialog
wesnoth.show_dialog(wml_dialog_table, [pre_show_function, [post_show_function]])
Displays a dialog box described by a WML table and returns:
if the dialog was dismissed by a button click, the integer value associated to the button via the "return_value" keyword.
if the dialog was closed with the enter key, -1.
if the dialog was closed with the escape key, -2.
The dialog box is equivalent to the resolution section of a GUI window as described in GUIToolkitWML and must therefore contain at least the following children: [tooltip], [helptip], and [grid]. The [grid] must contain nested [row], [column] and [grid] tags which describe the layout of the window. (More information can be found in GUILayout; suffice to say that the basic structure is grid -> row -> column -> widget, where the widget is considered to be in a cell defined by the row and column of the grid. A list of widgets can be found at GUIWidgetInstanceWML.)
Two optional functions can be passed as second and third arguments; the first one is called once the dialog is created and before it is shown; the second one is called once the dialog is closed. These functions are helpful in setting the initial values of the fields and in recovering the final user values. These functions can call the #wesnoth.set_dialog_value, #wesnoth.get_dialog_value, and #wesnoth.set_dialog_callback functions for this purpose.
This function should be called in conjunction with #wesnoth.synchronize_choice, in order to ensure that only one client displays the dialog and that the other ones recover the same input values from this single client.
The example below defines a dialog with a list and two buttons on the left, and a big image on the right. The preshow function fills the list and defines a callback on it. This select callback changes the displayed image whenever a new list item is selected. The postshow function recovers the selected item before the dialog is destroyed.
local helper = wesnoth.require "lua/helper.lua"
local T = helper.set_wml_tag_metatable {}
local _ = wesnoth.textdomain "wesnoth"

local dialog = {
  T.tooltip { id = "tooltip_large" },
  T.helptip { id = "tooltip_large" },
  T.grid { T.row {
    T.column { T.grid {
      T.row { T.column { horizontal_grow = true, T.listbox { id = "the_list",
        T.list_definition { T.row { T.column { horizontal_grow = true,
          T.toggle_panel { T.grid { T.row {
            T.column { horizontal_alignment = "left", T.label { id = "the_label" } },
            T.column { T.image { id = "the_icon" } }
          } } }
        } } }
      } } },
      T.row { T.column { T.grid { T.row {
        T.column { T.button { id = "ok", label = _"OK" } },
        T.column { T.button { id = "cancel", label = _"Cancel" } }
      } } } }
    } },
    T.column { T.image { id = "the_image" } }
  } }
}

local function preshow()
    local t = { "Ancient Lich", "Ancient Wose", "Elvish Avenger" }
    local function select()
        local i = wesnoth.get_dialog_value "the_list"
        local ut = wesnoth.unit_types[t[i]].__cfg
        wesnoth.set_dialog_value(string.gsub(ut.profile, "([^/]+)$", "transparent/%1"), "the_image")
    end
    wesnoth.set_dialog_callback(select, "the_list")
    for i,v in ipairs(t) do
        local ut = wesnoth.unit_types[v].__cfg
        wesnoth.set_dialog_value(ut.name, "the_list", i, "the_label")
        wesnoth.set_dialog_value(ut.image, "the_list", i, "the_icon")
    end
    wesnoth.set_dialog_value(2, "the_list")
    select()
end

local li = 0
local function postshow()
    li = wesnoth.get_dialog_value "the_list"
end

local r = wesnoth.show_dialog(dialog, preshow, postshow)
wesnoth.message(string.format("Button %d pressed. Item %d selected.", r, li))
wesnoth.set_dialog_value
wesnoth.set_dialog_value(value, path, to, widget, id)
Sets the value of a widget on the current dialog. The value is given by the first argument; its semantic depends on the type of widget it is applied to. The last argument is the id of the widget. If it does not point to a unique widget in the dialog, some discriminating parents should be given on its left, making a path that is read from left to right by the engine. The row of a list is specified by giving the id' of the list as a first argument and the 1-based row number as the next argument.
-- sets the value of a widget "bar" in the 7th row of the list "foo"
wesnoth.set_value(_"Hello world", "foo", 7, "bar")
Notes: When the row of a list does not exist, it is created. The value associated to a list is the selected row.
wesnoth.get_dialog_value
wesnoth.get_dialog_value(path, to, widget, id)
Gets the value of a widget on the current dialog. The arguments described the path for reaching the widget (see #wesnoth.set_dialog_value).
(Version 1.13.0 and later only) For treeviews this function returns a table descibing the currently selected node. If for example in this treeview
+Section1
 +Subsection11
  *Item1
  *Item2
  *Item3
 +Subsection12
  *Item4
  *Item5
  *Item6
+Section2
 +Subsection21
  *Item7
  *Item8
  *Item9
 +Subsection22
  *Item10
  *Item11
  *Item12
Item 9 is selcted the value will be {2,1,3}
wesnoth.set_dialog_active
wesnoth.set_dialog_active(active?, path, to, widget, id)
Enables or disables a widget. The first argument is a boolean specifying whether the widget should be active (true) or inactive (false). The remaining arguments are the path to locate the widget in question (see #wesnoth.set_dialog_value).
wesnoth.set_dialog_callback
wesnoth.set_dialog_callback(callback_function, path, to, widget, id)
Sets the first argument as a callback function for the widget obtained by following the path of the other arguments (see #wesnoth.set_dialog_value). This function will be called whenever the user modifies something about the widget, so that the dialog can react to it.
wesnoth.set_dialog_markup
wesnoth.set_dialog_markup(allowed?, path, to, widget, id)
Sets the flag associated to a widget to enable or disable Pango markup. The new flag value is passed as the first argument (boolean), and the widget to modify is obtained by following the path of the other arguments (see #wesnoth.set_dialog_value). Most widgets start with Pango markup disabled unless this function is used to set their flag to true.
wesnoth.set_dialog_markup(true, "notice_label")
wesnoth.set_dialog_value("<big>NOTICE!</big>", "notice_label")
wesnoth.set_dialog_focus
wesnoth.set_dialog_focus(focused?, path, to, widget, id)
(Version 1.13.2 and later only)
Switches the keyboard focus to the widget found following the given path (see #wesnoth.set_dialog_value). This is often useful for dialogs containing a central listbox, so that it can be controlled with the keyboard as soon as it is displayed.
wesnoth.set_dialog_focus("my_listbox")
wesnoth.set_dialog_visible
wesnoth.set_dialog_visible(visible?, path, to, widget, id)
(Version 1.13.2 and later only)
Sets a widget's visibility status. The new status is passed as the first argument, and the path to the widget is specified by the remaining arguments (see #wesnoth.set_dialog_value). The following visibility statuses are recognized:
String value	Boolean shorthand	Meaning
visible	true	The widget is visible and handles events.
hidden		The widget is not visible, doesn't handle events, but still takes up space on the dialog grid.
invisible	false	The widget is not visible, doesn't handle events, and does not take up space on the dialog grid.
wesnoth.set_dialog_visible(false, "secret_button")
wesnoth.set_dialog_canvas
wesnoth.set_dialog_value(index, content, path, to, widget, id)
Sets the WML passed as the second argument as the canvas content (index given by the first argument) of the widget obtained by following the path of the other arguments (see #wesnoth.set_dialog_value). The content of the WML table is described at GUICanvasWML.
-- draw two rectangles in the upper-left corner of the window (empty path = window widget)
wesnoth.set_dialog_canvas(2, {
    T.rectangle { x = 20, y = 20, w = 20, h = 20, fill_color= "0,0,255,255" },
    T.rectangle { x = 30, y = 30, w = 20, h = 20, fill_color = "255,0,0,255" }
})
The meaning of the canvas index depends on the chosen widget. It may be the disabled / enabled states of the widget, or its background / foreground planes, or... For instance, overwriting canvas 1 of the window with an empty canvas causes the window to become transparent.
wesnoth.add_dialog_tree_node
wesnoth.add_dialog_tree_node(type, index, path, to, widget, id)
(Version 1.13.0 and later only)
Adds a childnode to a treeview widget or a treeview node. The type (id of the node definition) of the node is passed in the first parameter. The second parameter (integer) spcifies where the node should be inserted in the parentnode. The other arguments describe the path of the parent treeview (-node)
wesnoth.remove_dialog_item
wesnoth.remove_dialog_item(index, count, path, to, widget, id)
(Version 1.13.1 and later only)
Removes an item from a listbox, a multipage or a treeview. First parameter is the index of the item to delete, second parameter is the number of items to delete and the remaining parameters describe the path to the listbox, the multipage or the parent treview node.
wesnoth.is_skipping_messages
wesnoth.is_skipping_messages()
(Version 1.13.2 and later only)
Returns true if messages are currently being skipped, for example because the player has chosen to skip replay, or has pressed escape to dismiss a message.
wesnoth.skip_messages
wesnoth.skip_messages([skip?)
(Version 1.13.2 and later only)
Sets the skip messages flag. By default it sets it to true, but you can also pass false to unset the flag.
wesnoth.get_displayed_unit
wesnoth.get_displayed_unit()
Returns a proxy to the unit currently displayed in the side pane of the user interface, if any.
local name = tostring(wesnoth.get_displayed_unit().name)
wesnoth.theme_items
This field is not a function but an associative table. It links item names to the functions that describe their content. These functions are called whenever the user interface is refreshed. The description of an item is a WML table containing [element] children. Each subtag shall contain either a text or an image field that is displayed to the user. It can also contain a tooltip field that is displayed to the user when moused over, and a "help" field that points to the help section that is displayed when the user clicks on the theme item.
Note that the wesnoth.theme_items table is originally empty and using pairs or next on it will not return the items from the current theme. Its metatable ensures that the drawing functions of existing items can be recovered though, as long as their name is known. The example below shows how to modify the unit_status item to display a custom status:
local old_unit_status = wesnoth.theme_items.unit_status
function wesnoth.theme_items.unit_status()
    local u = wesnoth.get_displayed_unit()
    if not u then return {} end
        local s = old_unit_status()
        if u.status.entangled then
            table.insert(s, { "element", {
                image = "entangled.png",
                tooltip = _"entangled: This unit is entangled. It cannot move but it can still attack."
            } })
        end
    return s
end
The following is a list of valid entries in wesnoth.theme_items which will have an effect in the game. Unfortunately when this feature was created the full range of capabilities of the feature was never properly documented. The following list is automatically generated. To find out what each entry will do, you will have to make guesses and experiment, or read the source code at src/reports.cpp. If you find out what an entry does, you are more than welcome to edit the wiki and give a proper description to any of these fields.
unit_name
selected_unit_name
unit_type
selected_unit_type
unit_race
selected_unit_race
unit_side
selected_unit_side
unit_level
selected_unit_level
unit_amla
unit_traits
selected_unit_traits
unit_status
selected_unit_status
unit_alignment
selected_unit_alignment
unit_abilities
selected_unit_abilities
unit_hp
selected_unit_hp
unit_xp
selected_unit_xp
unit_advancement_options
selected_unit_advancement_options
unit_defense
selected_unit_defense
unit_vision
selected_unit_vision
unit_moves
selected_unit_moves
unit_weapons
highlighted_unit_weapons
selected_unit_weapons
unit_image
selected_unit_image
selected_unit_profile
unit_profile
tod_stats
time_of_day
unit_box
turn
gold
villages
num_units
upkeep
expenses
income
terrain_info
terrain
zoom_level
position
side_playing
observers
selected_terrain
edit_left_button_function
report_clock
report_countdown
helper.get_user_choice
helper.get_user_choice(message_table, options)
Displays a WML message box querying a choice from the user. Attributes and options are taken from given tables (see [message]). The index of the selected option is returned.
local result = helper.get_user_choice({ speaker = "narrator" }, { "Choice 1", "Choice 2" })