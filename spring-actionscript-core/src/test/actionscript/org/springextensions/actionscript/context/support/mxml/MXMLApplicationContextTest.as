/*
 * Copyright 2007-2008 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springextensions.actionscript.context.support.mxml {
	import flash.events.Event;
	import flash.events.IOErrorEvent;

	import flexunit.framework.TestCase;

	import mx.rpc.remoting.RemoteObject;

	import org.springextensions.actionscript.context.support.MXMLApplicationContext;
	import org.springextensions.actionscript.context.support.mxml.testclasses.ContextWithPropertyTag;
	import org.springextensions.actionscript.stage.FlexStageProcessorRegistry;
	import org.springextensions.actionscript.test.SASTestCase;

	public class MXMLApplicationContextTest extends SASTestCase {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function MXMLApplicationContextTest(methodName:String = null) {
			super(methodName);
		}

		// --------------------------------------------------------------------
		//
		// Tests: load()
		//
		// --------------------------------------------------------------------

		public function testLoad_shouldResolvePropertyPlaceholders():void {
			assertTrue(true);
			var context:MXMLApplicationContext = new MXMLApplicationContext();
			context.addConfig(ContextWithPropertyTag);

			context.addEventListener(Event.COMPLETE, addAsync(function(event:Event):void {
				var string1:String = context.getObject("string1");
				assertEquals("value of property 1", string1);

				var propertiesArray:Array = context.getObject("propertiesArray");
				assertNotNull(propertiesArray);
				assertEquals(3, propertiesArray.length);
				assertEquals("value of property 1", propertiesArray[0]);
				assertEquals("value of property 2", propertiesArray[1]);
				assertEquals("value of property 3", propertiesArray[2]);

				var remoteObjects:Array = context.getObjectNamesForType(RemoteObject);
				assertEquals(4, remoteObjects.length);

				for each (var remoteObjectName:String in remoteObjects) {
					var remoteObject:RemoteObject = context.getObject(remoteObjectName);
					assertNotNull(remoteObject);
					assertEquals("http://192.168.0.1:8000/application/messagebroker/amf", remoteObject.endpoint);
				}
			}, 2000));
			context.load();
		}

	}
}