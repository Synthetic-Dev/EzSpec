local Types = require(script.Parent.Types)

local executeTests = require(script.Parent.executeTests)
local prettyPrint = require(script.Parent.prettyPrint)

return function(config: Types.Config)
	local directories = config.directories
	if not directories then
		return print("No directories supplied for testing")
	end

	local ignoreNames = config.ignoreNames or { }

	local includeDescendants = not not config.includeDescendants
	config.verboseLogging = not not config.verboseLogging

	config.showOnlyFailures = not not config.showOnlyFailures
	config.showExecutionTime = not not config.showExecutionTime

	if config.useEmojis == nil then
		config.useEmojis = true
	end

	local function log(...)
		if config.verboseLogging then
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

			if
				table.find(ignoreNames, module.Name)
				or table.find(ignoreNames, string.sub(module.Name, 1, -6))
			then
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

			local context = {
				config = config;
				counts = counts;
				testDepth = 0;
			}

			dirResults[moduleName] = executeTests(tests, context)
		end

		results[dirName] = dirResults
	end

	log("Tests complete, outputting results")
	prettyPrint(results, counts, config)
end
