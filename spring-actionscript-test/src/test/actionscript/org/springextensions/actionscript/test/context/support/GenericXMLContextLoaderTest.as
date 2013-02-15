package org.springextensions.actionscript.test.context.support {
import flash.events.Event;

import flexunit.framework.Assert;

import org.flexunit.async.Async;

public class GenericXMLContextLoaderTest {
	private var contextLoader:GenericXMLContextLoader;
	
	public function GenericXMLContextLoaderTest() {
	}
	
	[Before]
	public function setUp():void {
		contextLoader = new GenericXMLContextLoader();
	}
	
	[After]
	public function tearDown():void {
		contextLoader = null;	
	}
	
	[Test]
	public function testIsContextLoaded():void {
		Assert.assertFalse(contextLoader.contextLoaded);
	}
	
	[Test(async)]
	public function testLoadContext_Pass():void {
		Async.handleEvent(this, contextLoader, Event.COMPLETE, onTestLoadContext_Pass);
		contextLoader.loadContext(["empty-context.xml"]);
	}
	
	private function onTestLoadContext_Pass(event:Event, passThroughData:Object=null):void {
		Assert.assertEquals(Event.COMPLETE, event.type);
		Assert.assertTrue(contextLoader.contextLoaded);
	}
	
	[Test(async)]
	public function testLoadContext_Fail():void {
		Async.handleEvent(this, contextLoader, Event.COMPLETE, onTestLoadContext_Fail);
		contextLoader.loadContext(["no-exist-context.xml"]);
	}
	
	private function onTestLoadContext_Fail(event:Event, passThroughData:Object=null):void {
		Assert.assertEquals(Event.COMPLETE, event.type);
		Assert.assertTrue(contextLoader.couldNotLoadContext);
	}
	
	[Test]
	public function testIsGenerateDefaultLocations():void {
		Assert.assertTrue(contextLoader.generateDefaultLocations);
	}
	
	[Test]
	public function testProcessLocations():void {
		var locations:Array = ["test-context.xml","test-alt-context.xml"];
		var locationsList:Array = contextLoader.processLocations(GenericXMLContextLoaderTest, locations);
		
		Assert.assertEquals(2, locationsList.length);
		Assert.assertEquals("test-context.xml", locationsList[0]);
		Assert.assertEquals("test-alt-context.xml", locationsList[1]);
		
		locationsList = contextLoader.processLocations(GenericXMLContextLoaderTest, []);
		
		Assert.assertEquals(1, locationsList.length);
		Assert.assertEquals("org/springextensions/actionscript/test/context/support/GenericXMLContextLoaderTest-context.xml", locationsList[0]);
	}
}
}