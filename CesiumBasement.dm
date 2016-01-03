world
	fps = 25		// 25 frames per second
	icon_size = 32	// 32x32 icon size by default

	view = "25x20"		// show up to 6 tiles outward from center (13x13 view)
	turf = /turf/floor

turf
	icon = 'structure.dmi'
	floor
		icon_state = "floor"
	wall
		icon_state = "wall"
		density = 1
		opacity = 1
	nicewall
		icon_state = "nicewall"
		density = 1
		opacity = 1

obj/light
	icon = 'structure.dmi'
	icon_state = "light"
	luminosity = 7

obj/door
	icon = 'structure.dmi'
	icon_state = "door"
	var/base_icon_state
	density = 1
	opacity = 1

	New()
		if (copytext(icon_state, 1, 6) == "open_")
			density = 0
			opacity = 0
			base_icon_state = copytext(icon_state, 6)
		else
			base_icon_state = icon_state
		..()

	Click()
		if (src in oview(1))
			sprite.Door(src)

	proc/Toggle()
		density = !density
		sd_SetOpacity(density)
		if (density)
			icon_state = base_icon_state
		else
			icon_state = "open_[base_icon_state]"

obj/light/overhead
	icon_state = "overhead_light"
	luminosity = 6

	New()
		..()
		icon_state = ""

atom/movable/bgsprite
	icon = 'avatar.dmi'
	screen_loc = "1,1"
	icon_state = "background"
	layer = 0

atom/movable/talksprite
	var/mob/with = null
	var/obj/door/door = null
	icon = 'avatar.dmi'
	screen_loc = "1,1"
	layer = 80
	maptext_width = 530
	maptext_height = 185
	maptext_x = 220
	maptext_y = 70

	proc/Door(obj/door/door)
		src.door = door
		with = null
		icon_state = door.density ? "door" : "open_door"
		if (!(sprite in usr.client.screen))
			usr.client.screen += sprite
		usr.client.in_conversation = 1

	proc/Converse(mob/who, t as text)
		with = who
		door = null
		icon_state = "talk_left"
		if (!(sprite in usr.client.screen))
			usr.client.screen += sprite
		usr.client.in_conversation = 1
		maptext = "<FONT FACE=Arial COLOR=black SIZE=+2><TEXT ALIGN=top>[t]</TEXT></FONT>"

	Click()
		if (with)
			src.Close()
			usr.client.mob = with
		else if (door)
			door.Toggle()
			icon_state = door.density ? "door" : "open_door"
		else
			src.Close()

	proc/Close()
		usr.client.screen -= src
		usr.client.in_conversation = 0
		maptext = null

	proc/ClickOther()
		if (door)
			src.Close()

var/atom/movable/bgsprite/bg = new/atom/movable/bgsprite()
var/atom/movable/talksprite/sprite = new/atom/movable/talksprite()

mob
	icon = 'player.dmi'
	Click()
		if (src in oview(2))
			sprite.Converse(src, "Hello, World!")

client
	New()
		src.mob = locate(/mob)
		screen += bg

	Click(object, location, control, params)
		if (in_conversation && object != sprite)
			sprite.ClickOther()
		else
			..(object, location, control, params)

	Move(loc, dir)
		if (in_conversation)
			// TODO: break out of conversation?
		else
			..(loc, dir)

	default_verb_category = "should not be here"
	show_popup_menus = 0
	show_verb_panel = 0
	var/in_conversation = 0
