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

	import org.as3commons.lang.StringUtils;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.config.impl.mxml.component.MXMLObjectDefinition;
	import org.springextensions.actionscript.ioc.config.impl.mxml.custom.AbstractCustomObjectDefinitionComponent;
	import org.springextensions.actionscript.ioc.objectdefinition.ChildContextObjectDefinitionAccess;
	import org.springextensions.actionscript.ioc.objectdefinition.IBaseObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinitionBuilder;
	import org.springextensions.actionscript.stage.DefaultFlexAutowiringStageProcessor;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class StageAutowireProcessor extends AbstractCustomObjectDefinitionComponent {

		public static const OBJECTSELECTOR_CHANGED_EVENT:String = "objectSelectorChanged";
		public static const OBJECTDEFINITIONRESOLVER_CHANGED_EVENT:String = "objectDefinitionResolverChanged";
		public static const AUTOWIREONCE_CHANGED_EVENT:String = "autowireOnceChanged";

		/**
		 * Creates a new <code>StageAutowireProcessor</code> instance.
		 */
		public function StageAutowireProcessor() {
			super();
		}

		private var _objectSelector:Object;
		private var _objectDefinitionResolver:String;
		private var _autowireOnce:Boolean = true;

		[Bindable(event="autowireOnceChanged")]
		public function get autowireOnce():Boolean {
			return _autowireOnce;
		}

		public function set autowireOnce(value:Boolean):void {
			if (_autowireOnce != value) {
				_autowireOnce = value;
				dispatchEvent(new Event(AUTOWIREONCE_CHANGED_EVENT));
			}
		}

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

		[Bindable(event="objectDefinitionResolverChanged")]
		public function get objectDefinitionResolver():String {
			return _objectDefinitionResolver;
		}

		public function set objectDefinitionResolver(value:String):void {
			if (_objectDefinitionResolver != value) {
				_objectDefinitionResolver = value;
				dispatchEvent(new Event(OBJECTDEFINITIONRESOLVER_CHANGED_EVENT));
			}
		}

		public override function execute(applicationContext:IApplicationContext, objectDefinitions:Object, defaultDefinition:IBaseObjectDefinition=null, parentDefinition:IObjectDefinition=null, parentId:String=null):void {
			var result:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionForClass(DefaultFlexAutowiringStageProcessor);
			result.objectDefinition.customConfiguration = resolveObjectSelectorName();
			result.objectDefinition.childContextAccess = ChildContextObjectDefinitionAccess.NONE;
			if (StringUtils.hasText(_objectDefinitionResolver)) {
				result.addPropertyReference("objectDefinitionResolver", _objectDefinitionResolver);
			}
			result.addPropertyValue("autowireOnce", _autowireOnce);
			objectDefinitions[this.id] = result.objectDefinition;
		}

		protected function resolveObjectSelectorName():* {
			return (_objectSelector is MXMLObjectDefinition) ? MXMLObjectDefinition(_objectSelector).id : _objectSelector;
		}

	}
}
