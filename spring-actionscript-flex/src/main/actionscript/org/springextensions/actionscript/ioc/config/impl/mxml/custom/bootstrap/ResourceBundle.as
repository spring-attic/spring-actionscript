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
	public class ResourceBundle extends BootstrapItemBase {
		public static const NAME_CHANGED_EVENT:String = "nameChanged";
		public static const LOCALE_CHANGED_EVENT:String = "localeChanged";

		private var _name:String;
		private var _locale:String;

		/**
		 * Creates a new <code>ResourceBundle</code> instance.
		 */
		public function ResourceBundle() {
			super();
		}

		[Bindable(event="nameChanged")]
		public function get name():String {
			return _name;
		}

		public function set name(value:String):void {
			if (_name != value) {
				_name = value;
				dispatchEvent(new Event(NAME_CHANGED_EVENT));
			}
		}

		[Bindable(event="localeChanged")]
		public function get locale():String {
			return _locale;
		}

		public function set locale(value:String):void {
			if (_locale != value) {
				_locale = value;
				dispatchEvent(new Event(LOCALE_CHANGED_EVENT));
			}
		}

	}
}
