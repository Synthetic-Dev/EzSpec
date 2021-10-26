local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EzSpec = require(ReplicatedStorage.EzSpec)
local this = EzSpec.this
local declare = EzSpec.declare

return {
	declare("this test will be focused", function(skip)
		this("123string").should.match("%d")
	end).focus();

	declare("this focused test will error", function(skip)
		this(2).equals(3)
	end).focus();

	declare("this test will be ran, but marked to be fixed", function(skip)
		error("this will never run")
	end).focus().fixme("has a problem that needs fixing");

	declare("this test will not run", function(skip)
		skip("this will never be shown")

		error("this will not be ran")
	end);
}
