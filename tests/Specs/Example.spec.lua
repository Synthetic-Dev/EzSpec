local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EzSpec = require(ReplicatedStorage.EzSpec)
local this = EzSpec.this
local declare = EzSpec.declare

return {
	declare("nil should never exist", function()
		this(nil).should.never.exist()
	end);

	declare("1 + 1 should equal 2", function()
		this(1 + 1).equals(2)
	end);

	declare("this test will skip", function(skip)
		skip("showing that the skip feature works")

		error("this error should not be shown")
	end);

	declare("math.random should return a number", function()
		this(math.random()).isType("number")
	end);

	declare("a part should be a 'BasePart'", function()
		local part = Instance.new("Part")
		this(part).will.be.aClass("BasePart")
		part:Destroy()
	end);

	declare("the ability to write sentences", function()
		this(true).allows.you.to.be.able.to.write.sentences.as.long.as.they.finish.with.a.valid.assertion.like.exists()
	end);

	declare("this test has nested tests", function()
		return {
			declare("test will be skipped", function(skip)
				skip("test was skipped")

				error("this will not be shown")
			end);

			declare("this test should pass", function()
				this(true).is.ok()
			end);

			declare("test has nested tests of its own!", function()
				return {
					declare("a double nested test", function()
						this("test").isType("string")
					end);
				}
			end);

			declare("this test will fail", function()
				this(function() end).will.fail()
			end);
		}
	end);

	declare("empty function will never error", function()
		this(function() end).will.never.error()
	end);

	declare("this test should fail", function()
		this("string").will.match("a pattern that does not match")
	end);

	declare("{1, 2, 3} should contain the number '2'", function()
		this({ 1; 2; 3; }).should.contain(2)
	end);

	declare("math.pi should be near 3", function()
		this(math.pi).should.be.near(3, 0.15)
	end);

	declare("4 should be between 2 and 4.1", function()
		this(4).should.be.between(2, 4.1)
	end);
}
