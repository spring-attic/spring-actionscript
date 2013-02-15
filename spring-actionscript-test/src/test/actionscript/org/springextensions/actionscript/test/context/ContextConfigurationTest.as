package org.springextensions.actionscript.test.context {
import flexunit.framework.Assert;

import org.as3commons.reflect.MetaData;
import org.as3commons.reflect.MetaDataArgument;
import org.springextensions.actionscript.test.context.objects.MockContextLoader;

public class ContextConfigurationTest {
	// Reference declaration for class to test
	private var classToTestRef : org.springextensions.actionscript.test.context.ContextConfiguration;
	
	private var contextConfiguration:ContextConfiguration;
	
	public function ContextConfigurationTest() {
	}
	
	[Before]
	public function setUp():void {
		contextConfiguration = createContextConfiguration(null);
	}
	
	[After]
	public function tearDown():void {
		contextConfiguration = null;	
	}
	
	[Test]
	public function testContextConfiguration():void {
		Assert.assertNotNull(contextConfiguration);	
	}
	
	[Test]
	public function testGet_inheritLocations():void {
		Assert.assertTrue(contextConfiguration.inheritLocations);
		
		var args:Array = [
			new MetaDataArgument("inheritLocations", "false")
		];
		
		contextConfiguration = createContextConfiguration(args);
		
		Assert.assertFalse(contextConfiguration.inheritLocations);
		
		args = [
			new MetaDataArgument("inheritLocations", "true")
		];
		
		contextConfiguration = createContextConfiguration(args);
		
		Assert.assertTrue(contextConfiguration.inheritLocations);
	}
	
	[Test]
	public function testGet_loader():void {
		Assert.assertEquals(IContextLoader, contextConfiguration.loader);
		
		var args:Array = [
			new MetaDataArgument("loader", "ClassDoesNotExist"),
		];
		
		contextConfiguration = createContextConfiguration(args);
		
		Assert.assertEquals(IContextLoader, contextConfiguration.loader);
		
		args = [
			new MetaDataArgument("loader", "org.springextensions.actionscript.test.context.objects.MockContextLoader"),
		];
		
		contextConfiguration = createContextConfiguration(args);
		
		Assert.assertEquals(MockContextLoader, contextConfiguration.loader);
	}
	
	[Test]
	public function testGet_locations():void {
		Assert.assertEquals(["empty-context.xml"].toString(), contextConfiguration.locations.toString());
		
		var args:Array = [
			new MetaDataArgument("locations", "empty-context.xml, test-context.xml"),
		];
		
		contextConfiguration = createContextConfiguration(args);
		
		Assert.assertEquals(2, contextConfiguration.locations.length);
		
		contextConfiguration = createContextConfiguration([]);
		
		Assert.assertEquals(0, contextConfiguration.locations.length);
	}
	
	[Test]
	public function testGet_name():void {
		Assert.assertEquals("ContextConfiguration", ContextConfiguration.name);
	}
	
	private function createContextConfiguration(arguments:Array):ContextConfiguration {
		var args:Array = [
			new MetaDataArgument("locations", "empty-context.xml"),
		];
		
		if(arguments == null) {
			arguments = args;
		}
		
		return new ContextConfiguration(new MetaData(ContextConfiguration.name, arguments));	
	}
}
}