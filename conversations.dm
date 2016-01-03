
proc/first_convo(talk_to as text, talk_from as text)
	if (talk_to == "first" && talk_from == "blue")
		return new/convo/example_2()
	else if (talk_to == "blue" && talk_from == "first")
		return new/convo/example_1()

/convo/example_1/Setup()
	You("Conversation Line 1, from you")
	Them("Conversation Line 2, from them")
	You("Conversation Line 3, from you")
	Them("Conversation Line 4, from them")

/convo/example_2/Setup()
	You("Conversation Line 5, from you")
	Them("Conversation Line 6, from them")
