local this = { }

function this:_assert(result, tail, ...)
	tail = tail or "pass"
	local invert = rawget(self, "_invert")

	assert(
		result,
		string.format(
			"Expected value to%s " .. tail,
			invert and " never" or "",
			...
		)
	)
end

function this:_assertValueType(type_s, methodName)
	local value = rawget(self, "_value")
	local typeOf = typeof(value)

	if typeof(type_s) == "table" then
		assert(
			table.find(type_s, typeOf) ~= nil,
			string.format(
				"Expected value to be one of '%s' for '%s', got '%s'",
				table.concat(type_s, "', '"),
				methodName,
				typeOf
			)
		)
	else
		assert(
			typeOf == type_s,
			string.format(
				"Expected value to be '%s' for '%s', got '%s'",
				type_s,
				methodName,
				typeOf
			)
		)
	end
end

function this:_result(func)
	local invert = rawget(self, "_invert")

	local returned = { func(); }
	local result = table.remove(returned, 1)
	if invert then
		result = not result
	end

	return result, table.unpack(returned)
end

function this.invert(self)
	rawset(self, "_invert", not rawget(self, "_invert"))
end
this.never = this.invert

function this.exist(self, value)
	return function()
		local result = self:_result(function()
			return value ~= nil
		end)

		self:_assert(result, "exist, got '%s'", tostring(value))
	end
end
this.exists = this.exist

function this.equal(self, value)
	return function(expectedValue)
		local result = self:_result(function()
			return value == expectedValue
		end)

		self:_assert(
			result,
			"equal '%s', got '%s'",
			tostring(expectedValue),
			tostring(value)
		)
	end
end
this.equals = this.equal

function this.isType(self, value)
	return function(expectedType)
		local result = self:_result(function()
			return typeof(value) == expectedType
		end)

		self:_assert(
			result,
			"be typeof '%s', got '%s'",
			expectedType,
			typeof(value)
		)
	end
end
this.aType = this.isType

function this.isClass(self, value)
	return function(expectedClassName)
		local result = self:_result(function()
			return typeof(value) == "Instance" and value:IsA(expectedClassName)
		end)

		self:_assert(
			result,
			"be instance of '%s', got '%s'",
			expectedClassName,
			typeof(value) == "Instance" and value.ClassName or typeof(value)
		)
	end
end
this.aClass = this.isClass

function this.error(self, value, index)
	self:_assertValueType("function", index)

	return function()
		local result, _err = self:_result(function()
			return pcall(value)
		end)

		self:_assert(not result, "error")
	end
end
this.errors = this.error
this.fail = this.error
this.fails = this.error
this.throw = this.error
this.throws = this.error

function this.match(self, value)
	return function(pattern)
		local result = self:_result(function()
			return string.match(tostring(value), pattern) ~= nil
		end)

		self:_assert(result, "match '%s'", pattern)
	end
end
this.matches = this.match

function this.contain(self, value, index)
	local validTypes = { "table"; "string"; }
	self:_assertValueType(validTypes, index)

	return function(expectedValue)
		local result = self:_result(function()
			if typeof(value) == "table" then
				for _, v in pairs(value) do
					if v == expectedValue then
						return true
					end
				end
			else
				return string.find(value, expectedValue, nil, true) ~= nil
			end

			return false
		end)

		self:_assert(result, "contain '%s'", tostring(expectedValue))
	end
end
this.contains = this.contain
this.has = this.contain

function this.containOnly(self, value, index)
	self:_assertValueType("table", index)

	return function(expectedType)
		local result = self:_result(function()
			for _, v in pairs(value) do
				if typeof(v) ~= expectedType then
					return false
				end
			end
			return true
		end)

		self:_assert(result, "contain only '%s' type", expectedType)
	end
end
this.containsOnly = this.containOnly
this.hasOnly = this.containOnly

this.__index = function(self, index)
	local meta = getmetatable(self)

	if string.sub(index, 1, 1) == "_" then
		return rawget(self, index) or rawget(meta, index)
	end

	local method = rawget(meta, index)
	if method and typeof(method) == "function" then
		local value = rawget(self, "_value")
		local result = method(self, value, index)
		if result ~= nil then
			return result
		end
	end

	return self
end

return function(value)
	return setmetatable({
		_value = value;
		_invert = false;
		_traceback = debug.traceback(2);
	}, this)
end
