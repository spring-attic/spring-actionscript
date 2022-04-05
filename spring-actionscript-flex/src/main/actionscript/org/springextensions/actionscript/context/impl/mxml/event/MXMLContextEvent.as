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
package org.springextensions.actionscript.context.impl.mxml.event {
	import flash.display.DisplayObject;
	import flash.events.Event;

	import org.springextensions.actionscript.context.IApplicationContext;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class MXMLContextEvent extends Event {

		public static const CREATED:String = "created";

		private var _applicationContext:IApplicationContext;

		/**
		 *
		 * @param type
		 */
		public function MXMLContextEvent(type:String, context:IApplicationContext) {
			super(type, false, false);
			_applicationContext = context;
		}

		public function get applicationContext():IApplicationContext {
			return _applicationContext;
		}

		public override function clone():Event {
			return new MXMLContextEvent(type, _applicationContext);
		}

		public override function toString():String {
			return formatToString("MXMLContextEvent");
		}
	}
}
