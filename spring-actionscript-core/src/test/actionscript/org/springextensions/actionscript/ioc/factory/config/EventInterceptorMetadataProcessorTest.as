/*
* Copyright 2007-2011 the original author or authors.
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
package org.springextensions.actionscript.ioc.factory.config {
	import flexunit.framework.TestCase;

	import org.as3commons.eventbus.IEventInterceptor;
	import org.as3commons.eventbus.impl.EventBus;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.config.testclasses.ArrayEvent;
	import org.springextensions.actionscript.ioc.factory.config.testclasses.EventClassInterceptor;
	import org.springextensions.actionscript.ioc.factory.config.testclasses.EventTypeInterceptor;
	import org.springextensions.actionscript.ioc.factory.config.testclasses.GlobalEventInterceptor;
	import org.springextensions.actionscript.ioc.factory.support.DefaultListableObjectFactory;

	public class EventInterceptorMetadataProcessorTest extends TestCase {

		{
			ArrayEvent;
		}

		private var _processor:EventInterceptorMetadataProcessor;
		private var _objectFactory:IObjectFactory;

		public function EventInterceptorMetadataProcessorTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			_processor = new EventInterceptorMetadataProcessor();
			_objectFactory = new DefaultListableObjectFactory()
			_processor.objectFactory = _objectFactory;
		}

		public function testGlobalInterceptor():void {
			var globalInterceptor:IEventInterceptor = new GlobalEventInterceptor();
			var type:Type = Type.forInstance(globalInterceptor);
			_processor.process(globalInterceptor, type, "EventInterceptor", "");
			assertEquals(1, (_objectFactory.eventBus as EventBus).getInterceptorCount());
		}

		public function testGlobalInterceptorWithTopic():void {
			var globalInterceptor:IEventInterceptor = new GlobalEventInterceptor();
			var type:Type = Type.forInstance(globalInterceptor);
			_processor.process(globalInterceptor, type, "EventInterceptor", "");
			assertEquals(1, (_objectFactory.eventBus as EventBus).getInterceptorCount("topic1"));
		}

		public function testGlobalInterceptorWithMultipleTopics():void {
			var globalInterceptor:IEventInterceptor = new GlobalEventInterceptor();
			var type:Type = Type.forInstance(globalInterceptor);
			_processor.process(globalInterceptor, type, "EventInterceptor", "");
			assertEquals(1, (_objectFactory.eventBus as EventBus).getInterceptorCount("topic2"));
			assertEquals(1, (_objectFactory.eventBus as EventBus).getInterceptorCount("topic3"));
		}

		public function testClassInterceptor():void {
			var classInterceptor:IEventInterceptor = new EventClassInterceptor();
			var type:Type = Type.forInstance(classInterceptor);
			_processor.process(classInterceptor, type, "EventInterceptor", "");
			assertEquals(1, (_objectFactory.eventBus as EventBus).getClassInterceptorCount(ArrayEvent));
		}

		public function testEventTypeInterceptor():void {
			var typeInterceptor:IEventInterceptor = new EventTypeInterceptor();
			var type:Type = Type.forInstance(typeInterceptor);
			_processor.process(typeInterceptor, type, "EventInterceptor", "");
			assertEquals(1, (_objectFactory.eventBus as EventBus).getEventInterceptorCount("reverseArray"));
		}

	}
}