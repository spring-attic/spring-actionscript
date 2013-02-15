package org.springextensions.actionscript.test.context {
import flexunit.framework.Assert;

import org.springextensions.actionscript.test.context.support.DependencyInjectionTestExecutionListener;

[ContextConfiguration(locations="empty-context.xml")]
public class TestContextManagerTest {
	private var testContextManager:TestContextManager;
	
	public function TestContextManagerTest() {
	}
	
	[Before]
	public function setUp():void {
		testContextManager = new TestContextManager(TestContextManagerTest);
	}
	
	[After]
	public function tearDown():void {
		testContextManager = null;	
	}
	
	[Test]
	public function testGet_testExecutionListeners():void {
		Assert.assertEquals(2, testContextManager.testExecutionListeners.length);
		
		testContextManager.registerTestExecutionListeners([new DependencyInjectionTestExecutionListener()]);
		
		Assert.assertEquals(3, testContextManager.testExecutionListeners.length);
	}
	
	[Test]
	public function testPrepareTestInstance():void {
		try {
			testContextManager.prepareTestInstance(this);
		} catch(e:Error) {
			if(e.message != "Failed to load IApplicationContext") {
				Assert.fail(e.message);
			}
		}
		finally {
			Assert.assertFalse(testContextManager.applicationContextLoaded);
		}
	}
	
	[Test]
	public function testRegisterTestExecutionListeners():void {
		var testExecutionListener:ITestExecutionListener = new DependencyInjectionTestExecutionListener();
		testContextManager.registerTestExecutionListeners([testExecutionListener]);
		
		Assert.assertEquals(3, testContextManager.testExecutionListeners.length);
		Assert.assertEquals(testExecutionListener, testContextManager.testExecutionListeners[2]);
	}
}
}