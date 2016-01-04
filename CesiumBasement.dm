world
	fps = 25		// 25 frames per second
	icon_size = 32	// 32x32 icon size by default

	view = "25x20"		// show up to 6 tiles outward from center (13x13 view)
	turf = /turf/floor

	New()
		..()
		world.log = file("debug.txt")

turf
	icon = 'structure.dmi'
	floor
		icon_state = "floor"
		elevator
			icon_state = "elevator_floor"
	wall
		icon_state = "wall"
		density = 1
		opacity = 1
	nicewall
		icon_state = "nicewall"
		density = 1
		opacity = 1

obj
	Click(location, control, params)
		if (src in oview(1))
			var/convo/convo = src.Interact()
			if (convo)
				usr.client.sprite.StartConversation(convo)
	proc/Interact()

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

	Interact()
		return new/convo/door(src)

	proc/Toggle()
		density = !density
		sd_SetOpacity(density)
		if (density)
			icon_state = base_icon_state
		else
			icon_state = "open_[base_icon_state]"

obj/panel
	icon = 'structure.dmi'
	icon_state = "elevator_panel"
	var/top = 0
	var/bottom = 0

	Interact()
		return new/convo/panel(src)

	proc/Query()
		return "[top][bottom]"

	proc/PressTop()
		top = !top

	proc/PressBottom()
		bottom = !bottom

obj/door/elevator
	icon_state = "elevator_door"

	Interact()
		return new/convo/door/elevator(src)

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

proc/new_convo(name as text)
	var path = text2path("/convo/[name]")
	return new path()

convo
	proc/Begin(atom/movable/talksprite/sprite)
		throw EXCEPTION("Begin not defined on conversation!")

	proc/Next(atom/movable/talksprite/sprite, list/params)
		throw EXCEPTION("Next not defined on conversation!")

	proc/ClickOut(atom/movable/talksprite/sprite)
		sprite.Close()

convo/talk
	var/list/lines = list()
	var/seq
	var/mob/with

	New(mob/with)
		..()
		src.with = with
		Setup()

	proc/Setup()
		throw EXCEPTION("Setup not defined on conversation!")

	proc/You(line as text)
		lines.Add("L[line]")
	proc/Them(line as text)
		lines.Add("R[line]")
	proc/Become()
		lines.Add("B")

	Begin(atom/movable/talksprite/sprite)
		seq = 0
		src.Next(sprite)

	Next(atom/movable/talksprite/sprite)
		if (seq >= length(lines))
			sprite.Close()
			return
		seq += 1
		var cmd = copytext(lines[seq], 1, 2)
		var carg = copytext(lines[seq], 2)
		if (cmd == "L")
			sprite.Converse(carg, "talk_left", 220)
		else if (cmd == "R")
			sprite.Converse(carg, "talk_right", 47)
		else if (cmd == "B")
			sprite.Become(with)
			src.Next(sprite)

	ClickOut(atom/movable/talksprite/sprite)
		// do nothing

atom/movable/talksprite
	var/client/cli
	icon = 'avatar.dmi'
	screen_loc = "1,1"
	layer = 80
	maptext_width = 530
	maptext_height = 185
	maptext_x = 220
	maptext_y = 70
	var/convo/conversation = null

	New(client/cli)
		..()
		src.cli = cli

	proc/StartConversation(convo/con)
		conversation = con
		con.Begin(src)

	proc/Converse(t as text, icos as text, mpx as num)
		icon_state = icos
		maptext_x = mpx
		if (!(src in cli.screen))
			cli.screen += src
		cli.in_conversation = 1
		maptext = "<FONT FACE=Arial COLOR=black SIZE=+2><TEXT ALIGN=top>[t]</TEXT></FONT>"

	proc/Become(mob/with)
		cli.mob = with
		usr = with

	Click(location, control, params)
		var p = params2list(params)
		conversation.Next(src, p)

	proc/Close()
		cli.screen -= src
		cli.in_conversation = 0
		maptext = null
		conversation = null

	proc/ClickOther()
		conversation.ClickOut(src)

var/atom/movable/bgsprite/bg = new/atom/movable/bgsprite()

mob
	icon = 'player.dmi'
	icon_state = "first"
	var/convo/next_conversation
	Click()
		if (src in oview(2))
			if (!next_conversation)
				next_conversation = first_convo(src, usr)
			if (next_conversation)
				usr.client.sprite.StartConversation(next_conversation)

client
	var/atom/movable/talksprite/sprite

	New()
		sprite = new/atom/movable/talksprite(src)
		src.mob = locate(/mob)
		screen += bg

	Click(object, location, control, params)
		world.log << "CLICK [object] @ [location] @ [control] @ [params]"
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
