local suffixes = { "s"; "ms"; "μs"; "ns"; }
local function suffixedTime(num)
	local suffix = 1
	while num < 1 do
		num *= 1e3
		suffix += 1
	end

	return string.format("%.01f", num) .. suffixes[suffix]
end

return function(results, counts)
	local formattedCounts = string.format(
		"%d Passed, %d Skipped, %d Failed",
		table.unpack(counts)
	)

	local output = {
		" "
			.. string.rep(" ", (#formattedCounts / 2) - 10)
			.. "—— EzSpec Results ——";
		" " .. formattedCounts .. "\n";
	}

	for dirName, dirResults in pairs(results) do
		table.insert(output, "\t📁 " .. dirName)

		for moduleName, moduleResult in pairs(dirResults) do
			if typeof(moduleResult) == "string" then
				table.insert(output, "\t\t🧪 " .. moduleName)
				table.insert(output, "\t\t\t🛑 " .. moduleResult)

				continue
			end

			local longest = 0

			local fails = { }
			local passes = { }
			local skips = { }

			for testName, result in pairs(moduleResult.results) do
				local emoji = "🔴"
				local section = fails

				if result.skipped then
					emoji = "🟡"
					section = skips
				elseif result.passed then
					emoji = "🟢"
					section = passes
				end

				local name = "\t\t\t" .. emoji .. " " .. testName
				local length = #name

				local timeStr
				if result.time then
					timeStr = suffixedTime(result.time)
					length += #timeStr
				end

				if length > longest then
					longest = length
				end

				table.insert(section, {
					name = name;
					msg = result.err and " :: " .. string.gsub(
						result.err,
						"^%s*[%w%.]-:%d-:%s*",
						""
					);
					time = timeStr;
				})
			end

			local moduleEnd = ""
			if moduleResult.time then
				local moduleTime = suffixedTime(moduleResult.time)
				moduleEnd = " "
					.. string.rep(".", longest - #moduleName - #moduleTime - 4)
					.. moduleTime
			end

			table.insert(output, "\t\t🧪 " .. moduleName .. moduleEnd)

			for _, section in pairs({ fails; passes; skips; }) do
				for _, result in pairs(section) do
					local line = result.name
					if result.msg or result.time then
						local join
						if result.time then
							join = " "
								.. string.rep(
									".",
									longest - #result.name - #result.time
								)
								.. result.time
						else
							join = string.rep(" ", longest - #result.name)
						end

						line ..= join .. (result.msg and result.msg or "")
					end

					table.insert(output, line)
				end
			end
		end
	end

	print("\n", table.concat(output, "\n"), "\n")
end
