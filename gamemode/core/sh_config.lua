function GM:OnConfigLoaded()
	lia.config.Register("color", {
		name = "Color",
		type = "color",
		default = color_white,
	})
end