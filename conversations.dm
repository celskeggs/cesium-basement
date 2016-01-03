
proc/first_convo(mob/talk_to, mob/talk_from)
	if (talk_to.icon_state == "blue" && talk_from.icon_state == "first")
		return new/convo/talk/example_1(talk_to)
	else if (talk_to.icon_state == "first" && talk_from.icon_state == "blue")
		return new/convo/talk/example_2(talk_to)

proc/click_convo(obj/o)
	if (istype(o, /obj/door))
		return new/convo/door(o)

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
	New(door)
		..()
		src.door = door
	Begin(atom/movable/talksprite/sprite)
		sprite.Converse("", door.density ? "door" : "open_door", 0);
	Next(atom/movable/talksprite/sprite)
		door.Toggle()
		src.Begin(sprite)
