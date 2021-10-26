export type Config = {
	directories: { [number]: Instance; };
	ignoreNames: { [number]: string; };
	includeDescendants: boolean?;
	verboseLogging: boolean?;
	showOnlyFailures: boolean?;
	showExecutionTime: boolean?;
	useEmojis: boolean?;
}

export type Test = {
	Name: string;
	_func: TestFunction;

	_focus: boolean;
	_fixme: string?;

	focus: (Test) -> nil;
	fixme: (Test, reason: string) -> nil;
}

export type Tests = {
	[number]: Test;
}

export type SkipFunction = (reason: string) -> nil
export type TestFunction = (skip: SkipFunction) -> Tests?

return nil
