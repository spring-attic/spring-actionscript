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
package org.springextensions.actionscript.ioc.factory.config.testclasses {
	import flash.events.Event;

	import org.as3commons.eventbus.IEventInterceptor;
	import org.as3commons.eventbus.IEventBus;

	public class AbstractAnnotatedEventInterceptor implements IEventInterceptor {


		public function get eventBus():IEventBus {
			//TODO Auto-generated method stub
			return null;
		}

		public function set eventBus(value:IEventBus):void {
			//TODO Auto-generated method stub
		}


		private var _blockEvent:Boolean;

		public function AbstractAnnotatedEventInterceptor(block:Boolean = true) {
			super();
			_blockEvent = block;
		}

		public function get blockEvent():Boolean {
			return _blockEvent;
		}

		public function set blockEvent(value:Boolean):void {
			_blockEvent = value;
		}

		public function intercept(event:Event):void {
		}
	}
}