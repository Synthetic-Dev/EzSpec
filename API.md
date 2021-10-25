# API

```Lua
function EzSpec.runTests(config: dictionary)
```
Runs tests based on the provided `config`

* `config.directories: array` - An array of instances used to search for .spec files
* `config.ignoreNames: array` - An array of file names to ignore
* `config.includeDescendants: boolean` - Defines whether to search for .spec files in descendants or in children
* `config.verboseLogging: boolean` - Whether verbose logging is enabled
* `config.showOnlyFailures: boolean` - If only tests that fail should be shown
* `config.showExecutionTime: boolean` - If the time taken to execute should be shown next to each test

---

```Lua
function EzSpec.declare(name: string, test: function)
```
Creates a new test object with the given `name` and `test` function

---

```Lua
function EzSpec.this(value: any)
```
Takes a value that can then be used for assertions

* `.invert`, `.never` - Inverts the final assertion
* `.exist()`, `.exists()` - Asserts that `value ~= nil`
* `.equal(expectedValue: any)`, `.equals(expectedValue: any)` - Asserts that `value == expectedValue`
* `.isType(expectedType: string)`, `.aType(expectedType: string)` - Asserts `typeof(value)` is equal to `expectedType`
* `.isClass(expectedClassName: string)`, `.aClass(expectedClassName: string)` - Asserts `value:IsA(expectedClassName)`
* `.error()`, `.errors()`, `.fail()`, `.fails()`, `.throw()`, `.throws()` - Asserts that `value` will error
* `.match(pattern: string)`, `.matches(pattern: string)` - Asserts that `value` matches the given `pattern`
* `.contain(expectedValue: any)`, `.contains(expectedValue: any)`, `.has(expectedValue: any)` - Asserts that `value` contains the `expectedValue`
* `.containOnly(expectedType: string)`, `.containsOnly(expectedType: string)`, `.hasOnly(expectedType: string)` - Asserts that `value` only contains a type of `expectedType`