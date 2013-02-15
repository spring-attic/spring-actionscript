package org.springextensions.actionscript.test.context.support {
import org.flexunit.Assert;
import org.springextensions.actionscript.test.context.ContextCache;
import org.springextensions.actionscript.test.context.TestContext;
import org.springextensions.actionscript.test.context.flexunit4.EmptyContextTest;

public class DependencyInjectionTestExecutionListenerTest {
	// Reference declaration for class to test
	private var classToTestRef : org.springextensions.actionscript.test.context.support.DependencyInjectionTestExecutionListener;
	
	private var testExecutionListener:DependencyInjectionTestExecutionListener;
	
	public function DependencyInjectionTestExecutionListenerTest() {
	}
	
	[Before]
	public function setUp():void {
		testExecutionListener = new DependencyInjectionTestExecutionListener();	
	}
	
	[After]
	public function tearDown():void {
		testExecutionListener = null;	
	}
	
	
	[Test]
	public function testPrepareTestInstance():void {
		var testContext:TestContext = new TestContext(EmptyContextTest, new ContextCache());
		testExecutionListener.prepareTestInstance(testContext);
		
		Assert.assertNotNull(testContext.getApplicationContext());
	}
}
}