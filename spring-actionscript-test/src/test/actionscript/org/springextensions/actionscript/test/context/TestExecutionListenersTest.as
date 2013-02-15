package org.springextensions.actionscript.test.context {
import org.as3commons.reflect.MetaData;
import org.as3commons.reflect.MetaDataArgument;
import org.flexunit.Assert;

public class TestExecutionListenersTest {
	// Reference declaration for class to test
	private var classToTestRef : org.springextensions.actionscript.test.context.TestExecutionListeners;
	
	private var testExecutionListeners:TestExecutionListeners;
	
	public function TestExecutionListenersTest() {
	}
	
	[Before]
	public function setUp():void {
		testExecutionListeners = createTestExecutionListeners(null);
	}
	
	[After]
	public function tearDown():void {
		testExecutionListeners = null;	
	}
	
	[Test]
	public function testGet_inheritsListeners():void {
		Assert.assertTrue(testExecutionListeners.inheritsListeners);
		
		var args:Array = [
			new MetaDataArgument("", "Class1, Class2"),
			new MetaDataArgument("inheritsListeners", "false")
		];
		
		testExecutionListeners = createTestExecutionListeners(args);
		
		Assert.assertFalse(testExecutionListeners.inheritsListeners);
		
		args = [
			new MetaDataArgument("", "Class1, Class2"),
		];
		
		testExecutionListeners = createTestExecutionListeners(args);
		
		Assert.assertTrue(testExecutionListeners.inheritsListeners);
	}
	
	[Test]
	public function testGet_name():void {
		Assert.assertEquals("TestExecutionListeners", TestExecutionListeners.name);
	}
	
	[Test]
	public function testTestExecutionListeners():void {
		Assert.assertNotNull(testExecutionListeners);		
	}
	
	[Test]
	public function testGet_value():void {
		Assert.assertEquals(["Class1"].toString(), testExecutionListeners.value.toString());
		
		var args:Array = [
			new MetaDataArgument("", "Class1, Class2"),
			new MetaDataArgument("inheritsListeners", "true")
		];
		
		testExecutionListeners = createTestExecutionListeners(args);
		
		Assert.assertEquals(["Class1", "Class2"].toString(), testExecutionListeners.value.toString());
		
		testExecutionListeners = createTestExecutionListeners([]);
		
		Assert.assertEquals("", testExecutionListeners.value.toString());
	}
	
	private function createTestExecutionListeners(arguments:Array):TestExecutionListeners {
		var args:Array = [
			new MetaDataArgument("", "Class1"),
			new MetaDataArgument("inheritsListeners", "true")
		];
		
		if(arguments == null) {
			arguments = args;
		}
		
		return new TestExecutionListeners(new MetaData(TestExecutionListeners.name, arguments));	
	}
}
}