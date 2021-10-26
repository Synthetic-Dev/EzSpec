# API

```lua
function EzSpec.runTests(config: dictionary)
```
Runs tests based on the provided `config`

* `config.directories: array` - An array of instances used to search for `.spec` files
* `config.ignoreNames: array` - An array of file names to ignore
* `config.includeDescendants: boolean` - Defines whether to search for .spec files in descendants or in children
* `config.verboseLogging: boolean` - Whether verbose logging is enabled
* `config.showOnlyFailures: boolean` - If only tests that fail should be shown
* `config.showExecutionTime: boolean` - If the time taken to execute should be shown next to each test
* `config.useEmojis: boolean` - If emojis should be used when displaying test results, defaults to `true`

---

```lua
function EzSpec.declare(name: string, test: function)
```
Creates a new test object with the given `name` and `test` function

* `.focus()` - This will focus this test; if a set of tests contains 1 or more focused tests then only the focused tests will be run
* `.fixme(reason: string)` - Marks a test that needs to be fixed; these tests will not be run

---

```lua
function EzSpec.this(value: any)
```
Takes a value that can then be used for assertions

* `.invert`, `.never` - Inverts the final assertion
* `.exist()`, `.exists()`, `.ok()` - Asserts that `value ~= nil`
* `.equal(expectedValue: any)`, `.equals(...)` - Asserts that `value == expectedValue`
* `.isType(expectedType: string)`, `.aType(...)` - Asserts `typeof(value)` is equal to `expectedType`
* `.isClass(expectedClassName: string)`, `.aClass(...)` - Asserts `value:IsA(expectedClassName)`
* `.error()`, `.errors()`, `.fail()`, `.fails()`, `.throw()`, `.throws()` - Asserts that `value` will error
* `.match(pattern: string)`, `.matches(...)` - Asserts that `value` matches the given `pattern`
* `.contain(expectedValue: any)`, `.contains(...)`, `.has(...)` - Asserts that `value` contains the `expectedValue`
* `.containOnly(expectedType: string)`, `.containsOnly(...)`, `.hasOnly(...)` - Asserts that `value` only contains a type of `expectedType`
* `.near(nearValue: number, nearLimit: number?)`, `.nears(...)`, `.nearly(...)` - Asserts that `value` is within a range of `nearValue ± nearLimit`, where `nearLimit` defaults to `1e-3`
* `.between(minValue: number, maxValue: number)` - Asserts that `value` is between `minValue` and `maxValue`

You can also write sentences with `this` as long as they end with a valid assertion.
```lua
this(true).we.can.assume.that.this.will.always.exist()
```