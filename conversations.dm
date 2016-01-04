
proc/first_convo(mob/talk_to, mob/talk_from)
	if (talk_to.icon_state == "blue" && talk_from.icon_state == "first")
		return new/convo/talk/example_1(talk_to)
	else if (talk_to.icon_state == "first" && talk_from.icon_state == "blue")
		return new/convo/talk/example_2(talk_to)

/convo/talk/example_1/Setup()
	You("Conversation Line 1, from you")
	Them("Conversation Line 2, from them")
	You("Conversation Line 3, from you")
	Them("Conversation Line 4, from them")
	Become()

/convo/talk/example_2/Setup()
	You("Conversation Line 5, from you")
	Them("Conversation Line 6, from them")

/convo/door
	var/obj/door/door
	var/base_icon_state = "door"
	New(door)
		..()
		src.door = door
	Begin(atom/movable/talksprite/sprite)
		sprite.Converse("", door.density ? base_icon_state : "open_[base_icon_state]", 0);
	Next(atom/movable/talksprite/sprite)
		door.Toggle()
		src.Begin(sprite)

/convo/door/elevator
	base_icon_state = "elevator_door"
	Next(atom/movable/talksprite/sprite)
		// you can't open an elevator door like that!
		sprite.Close()

/convo/panel
	var/obj/panel/panel
	var/base_icon_state = "panel"
	New(panel)
		..()
		src.panel = panel
	Begin(atom/movable/talksprite/sprite)
		var sym = panel.Query()
		sprite.Converse("", "[base_icon_state][sym]", 0);
	Next(atom/movable/talksprite/sprite, list/params)
		if (text2num(params["icon-y"]) >= 320)
			panel.PressTop()
		else
			panel.PressBottom()
		src.Begin(sprite)