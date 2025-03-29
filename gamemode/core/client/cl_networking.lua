net.Receive( "lia.character.Create", function()

end )

net.Receive( "lia.character.Delete", function()

end )

net.Receive( "lia.character.Load", function()

end )

net.Receive( "lia.character.UpdateVar", function()
	local id = net.ReadUInt( 32 )
	local sName = net.ReadString()
	local sValue = net.ReadType()

	if lia.character.loaded[ id ] then
		lia.character.loaded[ id ].vars[ sName ] = sValue
	end
end )

net.Receive( "lia.option.Set", function()
	local sName = net.ReadString()
	local sValue = net.ReadType()

	lia.option.Set( sName, sValue )
end )

net.Receive( "lia.config.Set", function()
	local sName = net.ReadString()
	local sValue = net.ReadType()

	lia.config.values[ sName ] = sValue
end )