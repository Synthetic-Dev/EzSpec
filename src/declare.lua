local Types = require(script.Parent.Types)

local declare = { }

declare.__index = function(self, index)
	if string.sub(index, 1, 1) == "_" then
		return rawget(self, index) or rawget(declare, index)
	end

	local method = rawget(declare, index)
	if method and typeof(method) == "function" then
		return function(...)
			method(self, ...)
			return self
		end
	end

	return self
end

declare.__newindex = function()
	error("'declare' is read-only")
end

declare.__call = function(self, ...)
	return rawget(self, "_func")(...)
end

function declare.focus(self)
	rawset(self, "_focus", true)
end

function declare.fixme(self, reason: string)
	rawset(self, "_fixme", reason)
end

return function(name: string, func: Types.TestFunction): Types.Test
	return setmetatable({
		Name = name;
		_func = func;

		_focus = false;
		_fixme = nil;
	}, declare)
end
