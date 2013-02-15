/*
 * Copyright 2007-2010 the original author or authors.
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
package org.springextensions.actionscript.core.mvc {

	import flexunit.framework.TestCase;

	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.context.support.AbstractApplicationContext;
	import org.springextensions.actionscript.core.event.EventBus;
	import org.springextensions.actionscript.core.mvc.event.MVCEvent;
	import org.springextensions.actionscript.objects.mvc.TestClassWithRouteEventsAnnotation;
	import org.springextensions.actionscript.objects.mvc.TestClassWithRouteMVCEventsAnnotation;

	public class MVCRouteEventsMetaDataPostProcessorTest extends TestCase {

		private var _check:Boolean = false;

		public function MVCRouteEventsMetaDataPostProcessorTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			super.setUp();
			EventBus.removeAll();
			_check = false;
		}

		public function testProcess():void {
			var context:AbstractApplicationContext = new AbstractApplicationContext();
			var testInstance:TestClassWithRouteMVCEventsAnnotation = context.createInstance(TestClassWithRouteMVCEventsAnnotation);
			var proc:MVCRouteEventsMetaDataProcessor = new MVCRouteEventsMetaDataProcessor();
			EventBus.addEventClassListener(MVCEvent, handleMVCEvent);
			var t:Type = Type.forInstance(testInstance);
			proc.process(testInstance, t, "RouteMVCEvents", "testName");
			testInstance.dispatch();
			assertEquals(_check, true);
		}

		private function handleMVCEvent(event:MVCEvent):void {
			_check = true;
		}
	}
}