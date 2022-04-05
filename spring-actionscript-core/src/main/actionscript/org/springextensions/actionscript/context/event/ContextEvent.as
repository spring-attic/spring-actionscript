/*
* Copyright 2007-2011 the original author or authors.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package org.springextensions.actionscript.context.event {

	import flash.events.Event;

	import org.springextensions.actionscript.context.IApplicationContext;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ContextEvent extends Event {

		public static const AFTER_DISPOSE:String = "afterApplicationContextDispose";
		public static const AFTER_INITIALIZED:String = "afterApplicationContextInitialized";
		private var _applicationContext:IApplicationContext;

		/**
		 * Creates a new <code>ContextEvent</code> instance.
		 */
		public function ContextEvent(type:String, context:IApplicationContext, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_applicationContext = context;
		}


		public function get applicationContext():IApplicationContext {
			return _applicationContext;
		}

		override public function clone():Event {
			return new ContextEvent(type, _applicationContext, bubbles, cancelable);
		}
	}
}
