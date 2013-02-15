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
package org.springextensions.actionscript.core.event {

	//import flash.events.Event;
	import flash.events.Event;
	import flexunit.framework.TestCase;
	
	import org.as3commons.reflect.MethodInvoker;

	public class EventBusTests extends TestCase {
		// please note that all test methods should start with 'test' and should be public
		
		private var _eventReceived:Boolean = false;

		public function EventBusTests(methodName:String = null) {
			//TODO: implement function
			super(methodName);
		}
		
		override public function setUp():void {
			EventBus.removeAll();
			_eventReceived = false;
		}
		
		public function testAddListener():void {
			EventBus.addListener(new MockEventBusListener());
		}

		public function testRemoveListener():void {
			var listener:IEventBusListener = new MockEventBusListener();
			EventBus.addListener(listener);
			EventBus.removeListener(listener);
		}

		public function testAddEventListener():void {
			EventBus.addEventListener("testType",new Function());
		}
		
		public function testRemoveEventListener():void {
			var f:Function = new Function();
			EventBus.addEventListener("testType",f);
			EventBus.removeEventListener("testType",f);
		}

		public function testAddEventListenerProxy():void {
			EventBus.addEventListenerProxy("testType",new MethodInvoker());
		}
		
		public function testRemoveEventListenerProxy():void {
			var m:MethodInvoker = new MethodInvoker();
			EventBus.addEventListenerProxy("testType",m);
			EventBus.removeEventListenerProxy("testType",m);
		}

		public function testDispatchToEventBusListener():void {
			var l:MockEventBusListener = new MockEventBusListener();
			EventBus.addListener(l);
			assertFalse(l.receivedEvent);
			EventBus.dispatch("testType");
			assertTrue(l.receivedEvent);
		}

		public function testDispatchToListener():void {
			EventBus.addEventListener("testType",testListener);
			assertFalse(_eventReceived);
			EventBus.dispatch("testType");
			assertTrue(_eventReceived);
		}
		
		public function testDispatchToClassListener():void {
			EventBus.addEventClassListener(MockCustomEvent,testListener);
			assertFalse(_eventReceived);
			EventBus.dispatchEvent(new MockCustomEvent());
			assertTrue(_eventReceived);
		}

		protected function testListener(event:Event):void {
			_eventReceived = true;
		}

	}
}

//import flash.events.Event;
//import org.springextensions.actionscript.core.event.IEventBusListener;
import flash.events.Event;
import org.springextensions.actionscript.core.event.IEventBusListener

class MockEventBusListener implements IEventBusListener{
	
	public var receivedEvent:Boolean = false;
	
	public function MockEventBusListener(){
		super();
	}
	
	public function onEvent(event:Event):void {
		receivedEvent = true;
	}
}

class MockCustomEvent extends Event {
	public function MockCustomEvent(){
		super("customEvent");
	}
}