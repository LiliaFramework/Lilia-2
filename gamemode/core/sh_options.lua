function GM:OnOptionsLoaded()
	lia.option.Register("language", {
		name = "Language",
		type = "string",
		default = "english",
		OnSet = function(sValue)
			lia.language.SetLanguage(sValue)
		end
	})
end