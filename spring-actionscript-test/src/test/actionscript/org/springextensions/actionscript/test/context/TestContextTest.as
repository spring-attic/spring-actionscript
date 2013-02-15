package org.springextensions.actionscript.test.context {
import flexunit.framework.Assert;

import org.as3commons.reflect.Type;
import org.springextensions.actionscript.test.context.flexunit4.EmptyContextTest;
import org.springextensions.actionscript.utils.ObjectUtils;

public class TestContextTest {
	// Reference declaration for class to test
	private var classToTestRef : org.springextensions.actionscript.test.context.TestContext;
	
	private var testContext:TestContext;
	
	public function TestContextTest() {
	}
	
	[Before]
	public function setUp():void {
		testContext = new TestContext(EmptyContextTest, new ContextCache());
		testContext.updateState(new TestContextTest(), 
			Type.forClass(TestContextTest).getMethod("testGetApplicationContext"), 
			new Error());	
	}
	
	[After]
	public function tearDown():void {
		testContext = null;	
	}
	
	[Test]
	public function testGetApplicationContext():void {
		Assert.assertNotNull(testContext.getApplicationContext());
	}
	
	[Test]
	public function testGetTestClass():void {
		Assert.assertNotNull(testContext.testClass);
	}
	
	[Test]
	public function testGetTestException():void {
		Assert.assertNotNull(testContext.testException);
	}
	
	[Test]
	public function testGetTestInstance():void {
		Assert.assertNotNull(testContext.testInstance);
	}
	
	[Test]
	public function testGetTestMethod():void {
		Assert.assertNotNull(testContext.testMethod);
	}
	
	[Test]
	public function testMarkApplicationContextDirty():void {
		testContext.markApplicationContextDirty();
		
		Assert.assertFalse(testContext.contextCache.contains(ObjectUtils.nullSafeToString(testContext.locations)));
	}
	
	[Test]
	public function testToString():void {
		var string:String = testContext.toString();
		
		Assert.assertTrue(string.length > 0);
	}	
	
	[Test]
	public function testUpdateState():void {
		testContext.updateState(this, null, new ReferenceError());
		
		Assert.assertEquals(this, testContext.testInstance);
		Assert.assertNull(testContext.testMethod);
		Assert.assertTrue(testContext.testException is ReferenceError);
	}
}
}