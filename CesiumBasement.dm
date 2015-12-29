/*
	These are simple defaults for your project.
 */

world
	fps = 25		// 25 frames per second
	icon_size = 32	// 32x32 icon size by default

	view = 6		// show up to 6 tiles outward from center (13x13 view)
	turf = /turf/floor

turf
	icon = 'turf.dmi'
	floor
		icon_state = "floor"
	wall
		icon_state = "wall"
		density = 1
		opacity = 1

obj/test
	icon = 'practice.dmi'
	icon_state = "test"

mob
	icon = 'player.dmi'
