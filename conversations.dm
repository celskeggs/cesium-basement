
proc/first_convo(talk_to as text, talk_from as text)
	if (talk_to == "blue" && talk_from == "first")
		return new/convo/talk/example_1()
	else if (talk_to == "first" && talk_from == "blue")
		return new/convo/talk/example_2()

proc/click_convo(obj/o)
	if (istype(o, /obj/door))
		return new/convo/door(o)

/convo/talk/example_1/Setup()
	You("Conversation Line 1, from you")
	Them("Conversation Line 2, from them")
	You("Conversation Line 3, from you")
	Them("Conversation Line 4, from them")

/convo/talk/example_2/Setup()
	You("Conversation Line 5, from you")
	Them("Conversation Line 6, from them")

/convo/door
	var/obj/door/door
	New(door)
		..()
		src.door = door
	Begin(mob/who)
		sprite.Converse(who, "", door.density ? "door" : "open_door", 0);
	Next(mob/who)
		door.Toggle()
		src.Begin(who)
		return 1
