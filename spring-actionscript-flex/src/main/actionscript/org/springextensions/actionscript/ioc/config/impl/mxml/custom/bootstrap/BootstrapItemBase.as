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

	import mx.core.IMXMLObject;

	import org.springextensions.actionscript.ioc.config.impl.mxml.ISpringConfigurationComponent;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class BootstrapItemBase extends EventDispatcher implements IMXMLObject, ISpringConfigurationComponent {
		public static const URL_CHANGED_EVENT:String = "urlChanged";

		private var _document:Object;
		private var _id:String;
		private var _url:String;

		/**
		 * Creates a new <code>BootstrapModuleBase</code> instance.
		 */
		public function BootstrapItemBase() {
			super();
		}

		[Bindable(event="urlChanged")]
		public function get url():String {
			return _url;
		}

		public function set url(value:String):void {
			if (_url != value) {
				_url = value;
				dispatchEvent(new Event(URL_CHANGED_EVENT));
			}
		}

		public function initialized(document:Object, id:String):void {
			_document = document;
			_id = id;

		}
	}
}
