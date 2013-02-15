package org.springextensions.actionscript.test.context.flexunit4 {
[ContextConfiguration(locations="empty-context.xml")]
[TestExecutionListeners("org.springextensions.actionscript.test.context.support.NotDependencyInjectionTestExecutionListener")]
public class SpringFlexUnit4ClassRunnerTestBase {
	public function SpringFlexUnit4ClassRunnerTestBase() {
	}
}
}