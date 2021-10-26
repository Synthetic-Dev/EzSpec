# EzSpec
A unit testing framework for Roblox and Luau!

Inspired by and forked from Boat's BoatTEST / Elttob's FusionCI

I was always discouraged from using TestEZ since it manipulated function environments in order to expose the API. EzSpec removes all of that and provides a minimalistic way of testing.

## Usage

### [Click here for API →](API.md)

---

#### Starting Tests:
This will run any `.spec` files that are descendants of `script.Parent.Specs`

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EzSpec = require(ReplicatedStorage.EzSpec)

EzSpec.runTests({
	directories = {
		script.Parent.Specs;
	};
	includeDescendants = true;
})
```

#### Benchmarking:

If the `showExecutionTime` flag is set to `true` in the config then the amount of time taken to execute will be shown next to each test
```lua
EzSpec.runTests({
	directories = {
		script.Parent.Specs;
	};
	showExecutionTime = true;
})
```

#### Spec files:
In order to be recognized by the framework files must end in `.spec`

They should be a module that returns an array of tests created using the `declare` method, see example below:
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EzSpec = require(ReplicatedStorage.EzSpec)
local this = EzSpec.this
local declare = EzSpec.declare

return {
	declare("this will pass", function(skip)
		this(nil).should.never.exist()
	end);

	declare("this test will skip", function(skip)
		skip("showing that the skip feature works")

		error("this error should not be shown")
	end);

	declare("this test should fail", function(skip)
		this("string").will.match("a pattern that does not match")
	end);
}
```
Tests will be executed and displayed in the order that they are added to the array. Except when being displayed they are grouped together as `failed`, `passed` and `skipped` tests.

#### Nested tests:
If the `test` function returns a table containing more tests then those tests will be run if the parent test passes and is not skipped.
See example below:

```lua
declare("this test has nested tests", function()
	-- Run this test's code here

	return {
		declare("a nested test with nested tests", function()
			-- Run this test's code here

			return {
				declare("this test will pass", function()
					this(true).exists()
				end);
			}
		end);
	}
end)
```