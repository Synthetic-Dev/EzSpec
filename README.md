# EzSpec
A unit testing framework for Roblox and Luau!
Inspired by and forked from Boat's BoatTEST / Elttob's FusionCI

I was always discouraged from using TestEZ since it manipulated function environments in order to expose the API. EzSpec removes all of that.

## Usage
[Click here for API →](API.md)

#### Starting Tests:
This will run any .spec files that are descendants of `script.Parent.Specs`

```Lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EzSpec = require(ReplicatedStorage.EzSpec)

EzSpec.runTests({
	directories = {
		script.Parent.Specs;
	};
	includeDescendants = true;
	-- verboseLogging = true;
	-- showOnlyFailures = true;
	-- showExecutionTime = true;
})

```

#### Spec files:
In order to be recognized by the framework files must end in .spec

They should be a module that returns an array of tests created using the `declare` method, see example below:
```Lua
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