local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EzSpec = require(ReplicatedStorage.EzSpec)

EzSpec.runTests({
	directories = {
		script.Parent.Specs;
	};
	includeDescendants = true;
	-- verboseLogging = true;
	showOnlyFailures = true;
	showExecutionTime = true;
})
