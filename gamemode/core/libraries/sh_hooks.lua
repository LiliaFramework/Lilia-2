HOOKS_CACHE = {}

hook.liaCall = hook.liaCall or hook.Call

function hook.Call(name, gm, ...)
	if SCHEMA then
		for k, v in pairs(SCHEMA) do
			local tab = _G[k]
			if not tab then continue end

			local fn = tab[name]
			if not fn then continue end

			local a, b, c, d, e, f = fn(tab, ...)
			if a != nil then
				return a, b, c, d, e, f
			end
		end
	end

	if lia.module then
		for k, v in pairs(lia.module.stored) do
			for k2, v2 in pairs(v) do
				if type(v2) == "function" and k2 == name then
					local a, b, c, d, e, f = v2(v, ...)

					if a != nil then
						return a, b, c, d, e, f
					end
				end
			end
		end
	end

    return hook.liaCall(name, gm, ...)
end