-- Functions for teleporting units.

-- These don't depend on any other macros.  Please don't change this.
e.

----
-- Teleports a unit matching FILTER to X,Y
--
-- For example, teleport player 3's leader to 4,5
-- TELEPORT_UNIT
--         side: 3
--         can_recruit: true
--     4, 5
TELEPORT_UNIT = (FILTER, X, Y) ->
    teleport
        filter: FILTER
        x: X
        y: Y
    redraw

----
-- Teleports a unit on tile OLD_X,OLD_Y to NEW_X,NEW_Y
--
-- For example, teleport any unit thats currently on 1,1 to 4,5
-- TELEPORT_TILE 1, 1, 4, 5
TELEPORT_TILE = (OLD_X, OLD_Y, NEW_X, NEW_Y) ->
    teleport
        filter:
            x: OLD_X
            y: OLD_Y
        x: NEW_X
        y: NEW_Y
    redraw

-- #define TELEPORT_OUT_ANIMATION
--     # Generalized silver mage teleport out (disappear) animation
--     #
--     # For example, to apply a teleport animation to a custom unit definition:
--     #![animation]
--     #!    apply_to=pre_teleport
--     #!    {TELEPORT_OUT_ANIMATION}
--     #![/animation]

--     start_time=-1200

--     teleport_sparkle_1_start_time=-1200
--     teleport_sparkle_2_start_time=-1000
--     teleport_sparkle_3_start_time=-800

--     [teleport_sparkle_1_frame]
--         duration=800
--         halo=halo/teleport-[9,8,1~9].png
--         halo_x=-10
--         halo_y=30~-30
--     [/teleport_sparkle_1_frame]
--     [teleport_sparkle_2_frame]
--         duration=800
--         halo=halo/teleport-[9,8,1~9].png
--         halo_x=0
--         halo_y=40~-40
--     [/teleport_sparkle_2_frame]
--     [teleport_sparkle_3_frame]
--         duration=800
--         halo=halo/teleport-[9,8,1~9].png
--         halo_x=10
--         halo_y=30~-30
--     [/teleport_sparkle_3_frame]

--     [frame]
--         duration=100
--         image_mod=~MASK(masks/teleport-mask-0.png)
--     [/frame]
--     [frame]
--         duration=100
--         image_mod=~MASK(masks/teleport-mask-1.png)
--     [/frame]
--     [frame]
--         duration=100
--         image_mod=~MASK(masks/teleport-mask-2.png)
--     [/frame]
--     [frame]
--         duration=100
--         image_mod=~MASK(masks/teleport-mask-3.png)
--     [/frame]
--     [frame]
--         duration=100
--         image_mod=~MASK(masks/teleport-mask-4.png)
--     [/frame]
--     [frame]
--         duration=100
--         image_mod=~MASK(masks/teleport-mask-5.png)
--     [/frame]
--     [frame]
--         duration=100
--         image_mod=~MASK(masks/teleport-mask-6.png)
--     [/frame]
--     [frame]
--         duration=100
--         image_mod=~MASK(masks/teleport-mask-7.png)
--     [/frame]
--     [frame]
--         duration=100
--         image_mod=~MASK(masks/teleport-mask-8.png)
--     [/frame]
--     [frame]
--         duration=100
--         image_mod=~MASK(masks/teleport-mask-9.png)
--     [/frame]
--     [frame]
--         duration=200
--         image="misc/blank-hex.png"
--     [/frame]
-- #enddef

-- #define TELEPORT_IN_ANIMATION
--     # Generalized silver mage teleport in (reappear) animation
--     #
--     # For example, to apply a teleport animation to a custom unit definition:
--     #![animation]
--     #!    apply_to=post_teleport
--     #!    {TELEPORT_IN_ANIMATION}
--     #![/animation]

--     start_time=-1200

--     teleport_sparkle_1_start_time=-1200
--     teleport_sparkle_2_start_time=-1000
--     teleport_sparkle_3_start_time=-800

--     [teleport_sparkle_1_frame]
--         duration=800
--         halo=halo/teleport-[9,8,1~9].png
--         halo_x=10
--         halo_y=-30~30
--     [/teleport_sparkle_1_frame]
--     [teleport_sparkle_2_frame]
--         duration=800
--         halo=halo/teleport-[9,8,1~9].png
--         halo_x=0
--         halo_y=-40~40
--     [/teleport_sparkle_2_frame]
--     [teleport_sparkle_3_frame]
--         duration=800
--         halo=halo/teleport-[9,8,1~9].png
--         halo_x=-10
--         halo_y=-30~30
--     [/teleport_sparkle_3_frame]
--     [frame]
--         duration=200
--         image="misc/blank-hex.png"
--     [/frame]
--     [frame]
--         duration=100
--         image_mod=~MASK(masks/teleport-mask-9.png)
--     [/frame]
--     [frame]
--         duration=100
--         image_mod=~MASK(masks/teleport-mask-8.png)
--     [/frame]
--     [frame]
--         duration=100
--         image_mod=~MASK(masks/teleport-mask-7.png)
--     [/frame]
--     [frame]
--         duration=100
--         image_mod=~MASK(masks/teleport-mask-6.png)
--     [/frame]
--     [frame]
--         duration=100
--         image_mod=~MASK(masks/teleport-mask-5.png)
--     [/frame]
--     [frame]
--         duration=100
--         image_mod=~MASK(masks/teleport-mask-4.png)
--     [/frame]
--     [frame]
--         duration=100
--         image_mod=~MASK(masks/teleport-mask-3.png)
--     [/frame]
--     [frame]
--         duration=100
--         image_mod=~MASK(masks/teleport-mask-2.png)
--     [/frame]
--     [frame]
--         duration=100
--         image_mod=~MASK(masks/teleport-mask-1.png)
--     [/frame]
--     [frame]
--         duration=100
--         image_mod=~MASK(masks/teleport-mask-0.png)
--     [/frame]
-- #enddef

-- #define TELEPORT_EFFECT_OBJECT_ID _ID_
--     # Creates and assigns a temporary object which applies the generalized silver mage
--     # teleport animations to the unit with the matching ID
--     #
--     # For example, to apply teleport animations to the unit 'Bob':
--     #!{TELEPORT_EFFECT_OBJECT_ID Bob}

--     [object]
--         silent=yes
--         duration=turn

--         [filter]
--             id={_ID_}
--         [/filter]

--         [effect]
--             apply_to=new_animation

--             [animation]
--                 apply_to=pre_teleport
--                 {TELEPORT_OUT_ANIMATION}
--             [/animation]

--             [animation]
--                 apply_to=post_teleport
--                 {TELEPORT_IN_ANIMATION}
--             [/animation]
--         [/effect]
--     [/object]
-- #enddef

-- #define TELEPORT_EFFECT_OBJECT
--     # Creates and assigns a temporary object which applies the generalized silver mage
--     # teleport animations to the primary unit
--     #
--     # For example, to apply teleport animations to the unit that triggered a 'move_to' event:
--     #!{TELEPORT_EFFECT_OBJECT}

--     [object]
--         silent=yes
--         duration=turn

--         [effect]
--             apply_to=new_animation

--             [animation]
--                 apply_to=pre_teleport
--                 {TELEPORT_OUT_ANIMATION}
--             [/animation]

--             [animation]
--                 apply_to=post_teleport
--                 {TELEPORT_IN_ANIMATION}
--             [/animation]
--         [/effect]
--     [/object]
-- #enddef
