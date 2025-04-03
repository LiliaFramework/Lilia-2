lia.option.Register("language", {
	name = "Language",
	type = lia.type.string,
	default = "eng",
})

lia.config.Register( "color", {
	name = "Color",
	type = lia.type.color,
	default = color_white,
} )

lia.config.Register( "startMoney", {
	name = "Start Money",
	type = lia.type.number,
	default = 10,
} )