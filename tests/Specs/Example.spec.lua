local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EzSpec = require(ReplicatedStorage.EzSpec)
local this = EzSpec.this
local declare = EzSpec.declare

return {
	declare("nil should never exist", function(skip)
		this(nil).should.never.exist()
	end);

	declare("1 + 1 should equal 2", function(skip)
		this(1 + 1).equals(2)
	end);

	declare("this test will skip", function(skip)
		skip("showing that the skip feature works")

		error("this error should not be shown")
	end);

	declare("math.random should return a number", function(skip)
		this(math.random()).isType("number")
	end);

	declare("a part should be a 'BasePart'", function(skip)
		local part = Instance.new("Part")
		this(part).will.be.aClass("BasePart")
		part:Destroy()
	end);

	declare("the ability to write sentences", function(skip)
		this(true).allows.you.to.be.able.to.write.sentences.as.long.as.they.finish.with.a.valid.assertion.like.exists()
	end);

	declare("empty function will never error", function(skip)
		this(function() end).will.never.error()
	end);

	declare("this test should fail", function(skip)
		this("string").will.match("a pattern that does not match")
	end);

	declare("empty function will never error", function(skip)
		this(function() end).will.never.error()
	end);

	declare("{1, 2, 3} should contain the number '2'", function(skip)
		this({ 1; 2; 3; }).should.contain(2)
	end);
}
