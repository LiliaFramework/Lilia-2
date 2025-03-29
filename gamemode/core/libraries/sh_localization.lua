lia.language = lia.language or {}
lia.language.data = lia.language.data or {}

function lia.language.Add( sName, tPhrases )
	if not sName or not tPhrases then return end

	if lia.language.data[ sName ] then
		lia.language.data[ sName ] = table.Merge( lia.language.data[ sName ], tPhrases )

		return
	end

	lia.language.data[ sName ] = tPhrases
end

function lia.language.GetPhrase( sPhrase, sLang )
	if sLang == nil then
		sLang = CLIENT and lia.option.Get("language", "eng") or "eng"
	end

	if lia.language.data[ sLang ] and lia.language.data[ sLang ][ sPhrase ] then
		return lia.language.data[ sLang ][ sPhrase ]
	end

	return sPhrase
end

hook.Run("OnLocalizationLoaded")