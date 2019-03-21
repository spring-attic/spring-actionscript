/*
* Copyright 2007-2012 the original author or authors.
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
package org.springextensions.actionscript.ioc.config.impl.mxml.custom.bootstrap {
	import flash.events.Event;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ResourceModule extends BootstrapModuleBase {
		public static const UPDATE_CHANGED_EVENT:String = "updateChanged";

		private var _update:Boolean = true;

		/**
		 * Creates a new <code>ResourceModule</code> instance.
		 */
		public function ResourceModule() {
			super();
		}

		[Bindable(event="updateChanged")]
		public function get update():Boolean {
			return _update;
		}

		public function set update(value:Boolean):void {
			if (_update != value) {
				_update = value;
				dispatchEvent(new Event(UPDATE_CHANGED_EVENT));
			}
		}

	}
}
