local suffixes = { "s"; "ms"; "μs"; "ns"; }
local function suffixedTime(num)
	local suffix = 1
	while num < 1 do
		num *= 1e3
		suffix += 1
	end

	return string.format("%.01f", num) .. suffixes[suffix]
end

return function(results, counts, config)
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

	local useEmojis = config.useEmojis

	for dirName, dirResults in pairs(results) do
		table.insert(output, "\t" .. (useEmojis and "📁 " or "") .. dirName)

		for moduleName, moduleTests in pairs(dirResults) do
			if typeof(moduleTests) == "string" then
				table.insert(
					output,
					"\t\t" .. (useEmojis and "🧪 " or "> ") .. moduleName
				)
				table.insert(
					output,
					"\t\t\t" .. (useEmojis and "🛑 " or "") .. moduleTests
				)
				continue
			end

			local longest = 0

			local function tabulateResults(tests)
				local fails = { }
				local passes = { }
				local skips = { }

				for _, testResult in pairs(tests.results) do
					local testName = testResult.name

					local marker = useEmojis and "🔴" or "[X]"
					local section = fails

					if testResult.skipped then
						if testResult.fixme then
							marker = useEmojis and "🔧" or "[?]"
						else
							marker = useEmojis and "🟡" or "[-]"
						end
						section = skips
					elseif testResult.passed then
						marker = useEmojis and "🟢" or "[+]"
						section = passes
					end

					local name = string.rep("\t", tests.depth)
						.. "\t\t"
						.. marker
						.. " "
						.. testName

					local length = #string.gsub(name, "\t", string.rep(" ", 4))

					if not useEmojis then
						length += 3
					end

					local timeStr
					if testResult.time then
						timeStr = suffixedTime(testResult.time)
						length += #timeStr
					end

					if length > longest then
						longest = length
					end

					table.insert(section, {
						name = name;
						msg = testResult.err and " :: " .. string.gsub(
							testResult.err,
							"^%s*[%w%.]-:%d-:%s*", -- Taken from BoatTEST, used to remove traceback from error
							""
						);
						time = timeStr;
						length = length;
						subSections = testResult.nestedTests
								and tabulateResults(
									testResult.nestedTests
								)
							or nil;
					})
				end

				return { fails; passes; skips; }
			end

			local moduleSections = tabulateResults(moduleTests)

			local moduleEnd = ""
			if moduleTests.time then
				local moduleTime = suffixedTime(moduleTests.time)
				moduleEnd = " "
					.. string.rep(".", longest - #moduleName - #moduleTime - 9)
					.. " "
					.. moduleTime
			end

			table.insert(
				output,
				"\t\t"
					.. (useEmojis and "🧪 " or "> ")
					.. moduleName
					.. moduleEnd
			)

			local function insertSections(sections)
				for _, section in pairs(sections) do
					for _, result in pairs(section) do
						local line = result.name
						if result.msg or result.time then
							local join
							if result.time then
								join = " "
									.. string.rep(
										".",
										longest - result.length + 4
									)
									.. " "
									.. result.time
							else
								join = string.rep(
									" ",
									longest - result.length + 5
								)
							end

							line ..= join .. (result.msg and result.msg or "")
						end

						table.insert(output, line)

						if result.subSections then
							insertSections(result.subSections)
						end
					end
				end
			end

			insertSections(moduleSections)
		end
	end

	print("\n", table.concat(output, "\n"), "\n")
end
