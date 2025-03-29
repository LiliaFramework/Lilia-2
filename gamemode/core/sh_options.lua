function GM:OnOptionsLoaded()
	lia.option.Register("language", {
		name = "Language",
		type = "string",
		default = "eng",
	})
end