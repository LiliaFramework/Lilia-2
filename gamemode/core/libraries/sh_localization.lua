lia.language = lia.language or {}
lia.language.stored = lia.language.stored or {}

function lia.language.Add( sName, tPhrases )
	if not sName or not tPhrases then return end

	if lia.language.stored[ sName ] then
		lia.language.stored[ sName ] = table.Merge( lia.language.stored[ sName ], tPhrases )

		return
	end

	lia.language.stored[ sName ] = tPhrases
end

function lia.language.GetPhrase( sPhrase, sLang )
	if sLang == nil then
		sLang = CLIENT and lia.option.Get("language", "eng") or "eng"
	end

	if lia.language.stored[ sLang ] and lia.language.stored[ sLang ][ sPhrase ] then
		return lia.language.stored[ sLang ][ sPhrase ]
	end

	return sPhrase
end

hook.Run("OnLocalizationLoaded")