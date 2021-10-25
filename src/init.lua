-- Taken from BoatTEST
return setmetatable({ }, {
	__index = function(self, index)
		local cached = rawget(self, index)
		if cached then
			return cached
		end

		local module = script:FindFirstChild(index)
		if not module then
			return nil
		end

		local value = require(module)
		rawset(self, index, value)

		return value
	end;

	__newindex = function()
		error("EzSpec is read-only")
	end;
})
