local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EzSpec = require(ReplicatedStorage.EzSpec)

EzSpec.runTests({
	directories = {
		script.Parent.Specs;
	};
	-- ignoreNames = {
	-- 	"ThisWillFailToRequire";
	-- 	"DeclareExamples";
	-- };
	includeDescendants = true;
	-- verboseLogging = true;
	-- showOnlyFailures = true;
	-- showExecutionTime = true;
	-- useEmojis = false;
})
