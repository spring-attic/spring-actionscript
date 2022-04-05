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
package org.springextensions.actionscript.ioc.config.impl.mxml.custom.stage {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.config.impl.mxml.ICustomObjectDefinitionComponent;
	import org.springextensions.actionscript.ioc.config.impl.mxml.component.MXMLObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IBaseObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class StageObjectProcessor extends MXMLObjectDefinition implements ICustomObjectDefinitionComponent, IEventDispatcher {

		public static const OBJECTSELECTOR_CHANGED_EVENT:String = "objectSelectorChanged";

		/**
		 * Creates a new <code>StageObjectProcessor</code> instance.
		 */
		public function StageObjectProcessor() {
			super();
		}

		private var _objectSelector:Object;

		[Bindable(event="objectSelectorChanged")]
		public function get objectSelector():Object {
			return _objectSelector;
		}

		public function set objectSelector(value:Object):void {
			if (_objectSelector != value) {
				_objectSelector = value;
				dispatchEvent(new Event(OBJECTSELECTOR_CHANGED_EVENT));
			}
		}

		public function execute(applicationContext:IApplicationContext, objectDefinitions:Object, defaultDefinition:IBaseObjectDefinition=null, parentDefinition:IObjectDefinition=null, parentId:String=null):void {
			initializeComponent(applicationContext, defaultDefinition);
			var definitions:Object = objectDefinitions;
			definition.customConfiguration = resolveObjectSelectorName();
			objectDefinitions[this.id] = definition;
			for (var name:String in this.objectDefinitions) {
				definitions[name] = this.objectDefinitions[name];
			}
		}

		protected function resolveObjectSelectorName():* {
			return (_objectSelector is MXMLObjectDefinition) ? MXMLObjectDefinition(_objectSelector).id : _objectSelector;
		}

	}
}
