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
		sLang = "eng"
	end

	print("Getting phrase: " .. sPhrase .. " in language: " .. sLang)

	if lia.language.data[ sName ] and lia.language.data[ sName ][ sPhrase ] then
		print("Found phrase: " .. lia.language.data[ sName ][ sPhrase ])
		return lia.language.data[ sName ][ sPhrase ]
	end

	return sPhrase
end

hook.Run("OnLocalizationLoaded")