lia.option = lia.option or {}
lia.option.stored = {}

function lia.option.Register( sName, tData )
	if not sName or not tData then return end

	lia.option.stored[ sName ] = tData
end

function lia.option.GetAll()
	return lia.option.stored
end

hook.Run("OnOptionsLoaded")