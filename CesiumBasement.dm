world
	fps = 25		// 25 frames per second
	icon_size = 32	// 32x32 icon size by default

	view = "12x9"		// show up to 6 tiles outward from center (13x13 view)
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

mob
	icon = 'player.dmi'
	Click()
		if (src in oview(1))
			usr.client.mob = src

client
	New()
		src.mob = locate(/mob)

	default_verb_category = "should not be here"
	show_popup_menus = 0
	show_verb_panel = 0
