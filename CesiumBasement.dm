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

obj/test
	icon = 'practice.dmi'
	icon_state = "test"

obj/light
	icon = 'structure.dmi'
	icon_state = "light"
	luminosity = 6

obj/light/overhead
	icon_state = "overhead_light"
	luminosity = 6

	New()
		..()
		icon_state = ""

atom/movable/talksprite
	var/mob/with = null
	icon = 'avatar.dmi'
	screen_loc = "1,1"
	layer = 80
	maptext_width = 530
	maptext_height = 185
	maptext_x = 220
	maptext_y = 70

	proc/Converse(mob/who, t as text)
		with = who
		if (!(sprite in usr.client.screen))
			usr.client.screen += sprite
		if (!usr.client.in_conversation)
			usr.client.in_conversation = 1
		maptext = "<FONT FACE=Arial COLOR=black SIZE=+2><TEXT ALIGN=top>[t]</TEXT></FONT>"

	Click()
		usr.client.screen -= src
		usr.client.in_conversation = 0
		usr.client.mob = with

var/atom/movable/talksprite/sprite = new/atom/movable/talksprite()

mob
	icon = 'player.dmi'
	Click()
		if (src in oview(2))
			sprite.Converse(src, "Hello, World!")

client
	New()
		src.mob = locate(/mob)

	Click(object, location, control, params)
		if (in_conversation && object != sprite)
			// NAH
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
