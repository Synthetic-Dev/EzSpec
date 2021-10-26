return function(test, context)
	local config = context.config

	local function log(...)
		if config.verboseLogging then
			local args = { ...; }
			print(
				string.rep("\t", context.testDepth)
						.. table.remove(args, 1)
					or "",
				table.unpack(args)
			)
		end
	end

	log("Running test '" .. test.Name .. "'")

	if context.focusedOnly and not test._focus then
		log("\tIGNORED (NOT FOCUSED)")
		return
	end

	local testResult = {
		name = test.Name;
		passed = false;
		skipped = true;
		fixme = false;
		err = nil;
		time = nil;
		nestedTests = nil;
	}

	if test._fixme then
		log("\tSKIPPED (NEEDS FIX)")
		context.counts[2] += 1

		if config.showOnlyFailures then
			return
		end

		testResult.skipped = true
		testResult.fixme = true
		testResult.err = test._fixme

		return testResult
	end

	local skipped = false
	local function skip(reason: string)
		skipped = true
		error(reason, 2)
	end

	local testStart = os.clock()

	local passed, result = pcall(test, skip)

	if skipped then
		log("\tSKIPPED")
		context.counts[2] += 1
	elseif passed then
		log("\tPASSED")
		context.counts[1] += 1
	else
		log("\tFAILED")
		context.counts[3] += 1
	end

	local executionTime
	if config.showExecutionTime then
		executionTime = os.clock() - testStart
		context.totalTime += executionTime
	end

	local allNestedTestsPassed = true
	local nestedTests
	if not skipped and typeof(result) == "table" and #result > 0 then
		local executeTests = require(script.Parent.executeTests)
		nestedTests = executeTests(result, context)

		if nestedTests.time then
			executionTime = executionTime or 0
			executionTime += nestedTests.time
		end

		for _, nestedTest in pairs(nestedTests.results) do
			if not (nestedTest.passed or nestedTest.skipped) then
				allNestedTestsPassed = false
				break
			end
		end
	end

	if
		(passed or skipped)
		and allNestedTestsPassed
		and config.showOnlyFailures
	then
		return
	end

	testResult.passed = passed
	testResult.skipped = skipped
	testResult.time = executionTime

	if nestedTests then
		testResult.nestedTests = nestedTests
	else
		testResult.err = result
	end

	return testResult
end
