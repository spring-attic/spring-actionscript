package org.springextensions.actionscript.test.context.flexunit4 {
import mx.logging.targets.TraceTarget;

import org.flexunit.Assert;
import org.springextensions.actionscript.context.IApplicationContext;
import org.springextensions.actionscript.context.IApplicationContextAware;
import org.springextensions.actionscript.ioc.factory.config.LoggingTargetFactoryObject;
import org.springextensions.actionscript.logging.SOSTarget;

[RunWith("org.springextensions.actionscript.test.context.flexunit4.SpringFlexUnit4ClassRunner")]
[ContextConfiguration(locations="test-context.xml, test-alt-context.xml")]
[TestExecutionListeners("org.springextensions.actionscript.test.context.support.DependencyInjectionTestExecutionListener", inheritsListeners="false")]
public class SpringFlexUnit4ClassRunnerTest extends SpringFlexUnit4ClassRunnerTestBase implements IApplicationContextAware {
	private var runner:SpringFlexUnit4ClassRunner;
	private var sosTarget:SOSTarget;
	private var traceTarget:TraceTarget;
	private var factory:LoggingTargetFactoryObject;
	
	public function SpringFlexUnit4ClassRunnerTest() {
	}
	
	private var _applicationContext:IApplicationContext;
	
	public function get applicationContext():IApplicationContext {
		return _applicationContext;
	}
	
	public function set applicationContext(value:IApplicationContext):void {
		_applicationContext = value;
	}	
	
	[Test]
	public function testApplicationContextAware():void {
		Assert.assertNotNull(_applicationContext);
		Assert.assertNotNull(_applicationContext.getObject("traceTarget"));
		Assert.assertNotNull(_applicationContext.getObject("sosTarget"));
	}
	
	[Test]
	public function testAfterDirtiesContext():void {
		Assert.assertNotNull(_applicationContext);
	}
}
}