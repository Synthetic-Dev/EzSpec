return function(name, func)
	return setmetatable({
		Name = name;
		_func = func;
	}, {
		__call = function(self, ...)
			return rawget(self, "_func")(...)
		end;
	})
end
