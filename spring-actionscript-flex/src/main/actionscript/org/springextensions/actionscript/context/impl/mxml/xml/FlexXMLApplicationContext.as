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
package org.springextensions.actionscript.context.impl.mxml.xml {

	import flash.display.DisplayObject;
	import flash.events.Event;

	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.impl.mxml.MXMLApplicationContextBase;
	import org.springextensions.actionscript.ioc.config.impl.xml.XMLObjectDefinitionsProvider;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.INamespaceHandler;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class FlexXMLApplicationContext extends MXMLApplicationContextBase {
		public static const CONFIG_LOCATIONS_CHANGED_EVENT:String = "configLocationsChanged";

		/**
		 * Creates a new <code>FlexXMLApplicationContext</code> instance.
		 */
		public function FlexXMLApplicationContext(parent:IApplicationContext=null, rootViews:Vector.<DisplayObject>=null, objFactory:IObjectFactory=null) {
			super(parent, rootViews, objFactory);
			var provider:XMLObjectDefinitionsProvider = new XMLObjectDefinitionsProvider();
			addDefinitionProvider(provider);
		}

		private var _configLocations:Array;

		[Bindable(event="configLocationsChanged")]
		public function get configLocations():Array {
			return _configLocations;
		}

		public function set configLocations(value:Array):void {
			if (_configLocations != value) {
				_configLocations = value;
				dispatchEvent(new Event(CONFIG_LOCATIONS_CHANGED_EVENT));
			}
		}

		override public function initializeContext():void {
			if (!contextInitialized) {
				var provider:XMLObjectDefinitionsProvider = XMLObjectDefinitionsProvider(definitionProviders[0]);
				for each (var location:* in _configLocations) {
					provider.addLocation(location);
				}
				super.initializeContext();
			}
		}

		public function addNamespaceHandler(namespaceHandler:INamespaceHandler):XMLObjectDefinitionsProvider {
			return XMLObjectDefinitionsProvider(definitionProviders[0]).addNamespaceHandler(namespaceHandler);
		}

		public function addNamespaceHandlers(namespaceHandlers:Vector.<INamespaceHandler>):XMLObjectDefinitionsProvider {
			return XMLObjectDefinitionsProvider(definitionProviders[0]).addNamespaceHandlers(namespaceHandlers);
		}

	}
}
