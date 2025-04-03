HOOKS_CACHE = {}

hook.ixCall = hook.ixCall or hook.Call

function hook.Call(name, gm, ...)
	local cache = HOOKS_CACHE[name]

	if (cache) then
		for k, v in pairs(cache) do
			local a, b, c, d, e, f = v(k, ...)

			if (a != nil) then
				return a, b, c, d, e, f
			end
		end
	end

	if (Schema and Schema[name]) then
		local a, b, c, d, e, f = Schema[name](Schema, ...)

		if (a != nil) then
			return a, b, c, d, e, f
		end
	end

	return hook.ixCall(name, gm, ...)
end

--- Runs the given hook in a protected call so that the calling function will continue executing even if any errors occur
-- while running the hook. This function is much more expensive to call than `hook.Run`, so you should avoid using it unless
-- you absolutely need to avoid errors from stopping the execution of your function.
-- @internal
-- @realm shared
-- @string name Name of the hook to run
-- @param ... Arguments to pass to the hook functions
-- @treturn[1] table Table of error data if an error occurred while running
-- @treturn[1] ... Any arguments returned by the hook functions
-- @usage local errors, bCanSpray = hook.SafeRun("PlayerSpray", Entity(1))
-- if (!errors) then
--     -- do stuff with bCanSpray
-- else
--     PrintTable(errors)
-- end
function hook.SafeRun(name, ...)
	local errors = {}
	local gm = gmod and gmod.GetGamemode() or nil
	local cache = HOOKS_CACHE[name]

	if (cache) then
		for k, v in pairs(cache) do
			local bSuccess, a, b, c, d, e, f = pcall(v, k, ...)

			if (bSuccess) then
				if (a != nil) then
					return errors, a, b, c, d, e, f
				end
			else
				ErrorNoHalt(string.format("[Helix] hook.SafeRun error for plugin hook \"%s:%s\":\n\t%s\n%s\n",
					tostring(k and k.uniqueID or nil), tostring(name), tostring(a), debug.traceback()))

				errors[#errors + 1] = {
					name = name,
					plugin = k and k.uniqueID or nil,
					errorMessage = tostring(a)
				}
			end
		end
	end

	if (Schema and Schema[name]) then
		local bSuccess, a, b, c, d, e, f = pcall(Schema[name], Schema, ...)

		if (bSuccess) then
			if (a != nil) then
				return errors, a, b, c, d, e, f
			end
		else
			ErrorNoHalt(string.format("[Helix] hook.SafeRun error for schema hook \"%s\":\n\t%s\n%s\n",
				tostring(name), tostring(a), debug.traceback()))

			errors[#errors + 1] = {
				name = name,
				schema = Schema.name,
				errorMessage = tostring(a)
			}
		end
	end

	local bSuccess, a, b, c, d, e, f = pcall(hook.ixCall, name, gm, ...)

	if (bSuccess) then
		return errors, a, b, c, d, e, f
	else
		ErrorNoHalt(string.format("[Lilia] hook.SafeRun error for gamemode hook \"%s\":\n\t%s\n%s\n",
			tostring(name), tostring(a), debug.traceback()))

		errors[#errors + 1] = {
			name = name,
			gamemode = "gamemode",
			errorMessage = tostring(a)
		}

		return errors
	end
end