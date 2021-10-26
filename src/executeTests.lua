local executeTest = require(script.Parent.executeTest)

return function(tests, context)
	local newContext = table.create(#context)
	if #context > 0 then
		table.move(context, 1, #context, 1, newContext)
	else
		for k, v in pairs(context) do
			newContext[k] = v
		end
	end

	context = newContext
	context.testDepth += 1

	local hasFocus = false
	for _, test in pairs(tests) do
		if test._focus then
			hasFocus = true
			break
		end
	end

	context.focusedOnly = hasFocus
	context.totalTime = 0

	local testResults = { }
	for _, test in pairs(tests) do
		local result = executeTest(test, context)

		if result then
			table.insert(testResults, result)
		end
	end

	return {
		depth = context.testDepth;
		results = testResults;
		time = context.config.showExecutionTime and context.totalTime;
	}
end
