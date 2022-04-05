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
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import mx.core.IFlexModuleFactory;
	import mx.core.IMXMLObject;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class StyleModule extends ResourceModule {

		public static const FLEXMODULEFACTORY_CHANGED_EVENT:String = "flexModuleFactoryChanged";

		private var _flexModuleFactory:IFlexModuleFactory;

		/**
		 * Creates a new <code>StyleModule</code> instance.
		 */
		public function StyleModule() {
			super();
		}

		public function get flexModuleFactory():IFlexModuleFactory {
			return _flexModuleFactory;
		}

		public function set flexModuleFactory(value:IFlexModuleFactory):void {
			if (_flexModuleFactory != value) {
				_flexModuleFactory = value;
				dispatchEvent(new Event(FLEXMODULEFACTORY_CHANGED_EVENT));
			}
		}

	}
}
