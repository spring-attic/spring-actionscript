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
package org.springextensions.actionscript.context {
	import org.springextensions.actionscript.eventbus.EventBusShareKind;
	import org.springextensions.actionscript.eventbus.EventBusShareSettings;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ContextShareSettings {

		/**
		 * Creates a new <code>ContextShareSettings</code> instance.
		 */
		public function ContextShareSettings() {
			super();
			_eventBusShareSettings = new EventBusShareSettings();
		}

		private var _shareDefinitions:Boolean = true;
		private var _shareProperties:Boolean = true;
		private var _shareSingletons:Boolean = true;
		private var _eventBusShareSettings:EventBusShareSettings;

		/**
		 * @default true
		 */
		public function get shareDefinitions():Boolean {
			return _shareDefinitions;
		}

		/**
		 * @private
		 */
		public function set shareDefinitions(value:Boolean):void {
			_shareDefinitions = value;
		}

		/**
		 *
		 */
		public function get eventBusShareSettings():EventBusShareSettings {
			return _eventBusShareSettings;
		}

		/**
		 * @private
		 */
		public function set eventBusShareSettings(value:EventBusShareSettings):void {
			_eventBusShareSettings = value;
		}

		/**
		 * @default true
		 */
		public function get shareProperties():Boolean {
			return _shareProperties;
		}

		/**
		 * @private
		 */
		public function set shareProperties(value:Boolean):void {
			_shareProperties = value;
		}

		/**
		 * @default true
		 */
		public function get shareSingletons():Boolean {
			return _shareSingletons;
		}

		/**
		 * @private
		 */
		public function set shareSingletons(value:Boolean):void {
			_shareSingletons = value;
		}


		public function toString():String {
			return "ContextShareSettings{shareDefinitions:" + _shareDefinitions + ", shareProperties:" + shareProperties + ", shareSingletons:" + shareSingletons + ", eventBusShareSettings:" + _eventBusShareSettings.toString() + "}";
		}


	}
}
