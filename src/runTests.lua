local prettyPrint = require(script.Parent.prettyPrint)

type configType = {
	directories: { [number]: Instance; };
	ignoreNames: { [number]: string; };
	includeDescendants: boolean?;
	verboseLogging: boolean?;
	showOnlyFailures: boolean?;
	showExecutionTime: boolean?;
}

return function(config: configType)
	local directories = config.directories
	if not directories then
		return print("No directories supplied for testing")
	end

	local ignoreNames = config.ignoreNames or { }

	local includeDescendants = not not config.includeDescendants
	local verboseLogging = not not config.verboseLogging

	local showOnlyFailures = not not config.showOnlyFailures
	local showExecutionTime = not not config.showExecutionTime

	local function log(...)
		if verboseLogging then
			print(...)
		end
	end

	local results = { }
	-- Passed, Skipped, Failed
	local counts = { 0; 0; 0; }

	for _, dir in pairs(directories) do
		local dirName = dir:GetFullName()
		local dirResults = { }

		log("Testing directory '" .. dirName .. "'")

		local objects
		if includeDescendants then
			objects = dir:GetDescendants()
		else
			objects = dir:GetChildren()
		end

		local modules = { }
		for _, object in pairs(objects) do
			if
				object:IsA("ModuleScript")
				and string.match(object.Name, "%.spec$")
			then
				local moduleName = string.sub(
					object:GetFullName(),
					#dirName + 2
				) --string.sub(string.sub(object:GetFullName(), #dirName + 2), 1, -6 )
				modules[moduleName] = object
			end
		end

		for moduleName, module in pairs(modules) do
			log("\tFound .spec '" .. moduleName .. "'")

			if table.find(ignoreNames, module.Name) then
				log("\tIgnoring .spec")
				continue
			end

			local success, tests = pcall(require, module)
			if not success then
				dirResults[moduleName] = tests
				continue
			elseif typeof(tests) ~= "table" then
				dirResults[moduleName] = ".spec module did not return a table"
				continue
			end

			local totalTime = 0

			local moduleResults = { }
			for _, test in pairs(tests) do
				log("\tRunning test '" .. test.Name .. "'")

				local skipped = false
				local function skip(reason: string)
					skipped = true
					error(reason, 2)
				end

				local testStart = os.clock()

				local passed, err = pcall(test, skip)

				if skipped then
					log("\t\tSKIPPED")
					counts[2] += 1
				elseif passed then
					log("\t\tPASSED")
					counts[1] += 1
				else
					log("\t\tFAILED")
					counts[3] += 1
				end

				local executionTime
				if showExecutionTime then
					executionTime = os.clock() - testStart
					totalTime += executionTime
				end

				if (passed or skipped) and showOnlyFailures then
					continue
				end

				moduleResults[test.Name] = {
					passed = passed;
					skipped = skipped;
					err = err;
					time = executionTime;
				}
			end

			dirResults[moduleName] = {
				results = moduleResults;
				time = showExecutionTime and totalTime;
			}
		end

		results[dirName] = dirResults
	end

	log("Tests complete, outputting results")
	prettyPrint(results, counts)
end
