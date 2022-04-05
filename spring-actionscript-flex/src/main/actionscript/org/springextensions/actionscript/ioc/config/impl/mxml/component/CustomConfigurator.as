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
package org.springextensions.actionscript.ioc.config.impl.mxml.component {

	import flash.errors.IllegalOperationError;
	import flash.events.Event;

	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.StringUtils;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.config.impl.mxml.custom.AbstractCustomObjectDefinitionComponent;
	import org.springextensions.actionscript.ioc.objectdefinition.IBaseObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.ICustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.util.ContextUtils;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class CustomConfigurator extends AbstractCustomObjectDefinitionComponent {
		public static const CLAZZ_CHANGED_EVENT:String = "clazzChanged";
		public static const REF_CHANGED_EVENT:String = "refChanged";

		/**
		 * Creates a new <code>CustomConfiguration</code> instance.
		 */
		public function CustomConfigurator() {
			super();
		}

		private var _clazz:Class;
		private var _ref:String;


		[Bindable(event="refChanged")]
		public function get ref():String {
			return _ref;
		}

		public function set ref(value:String):void {
			if (_ref != value) {
				_ref = value;
				dispatchEvent(new Event(REF_CHANGED_EVENT));
			}
		}

		[Bindable(event="clazzChanged")]
		public function get clazz():Class {
			return _clazz;
		}

		public function set clazz(value:Class):void {
			if (_clazz !== value) {
				_clazz = value;
				dispatchEvent(new Event(CLAZZ_CHANGED_EVENT));
			}
		}

		override public function execute(applicationContext:IApplicationContext, objectDefinitions:Object, defaultDefinition:IBaseObjectDefinition=null, parentDefinition:IObjectDefinition=null, parentId:String=null):void {
			if ((_clazz != null) || (StringUtils.hasText(_ref))) {
				var customConfiguration:Vector.<Object> = ContextUtils.getCustomConfigurationForObjectName(parentId, applicationContext.objectDefinitionRegistry);
				if (_clazz != null) {
					if (ClassUtils.isImplementationOf(_clazz, ICustomConfigurator, applicationContext.applicationDomain)) {
						var configurator:ICustomConfigurator = new _clazz();
						customConfiguration[customConfiguration.length] = configurator;
					} else {
						throw new IllegalOperationError(StringUtils.substitute("Clazz property of CustomConfigurator must be an implementation of ICustomConfigurator: {0}", _clazz));
					}
				} else {
					customConfiguration[customConfiguration.length] = new RuntimeObjectReference(_ref);
				}
				applicationContext.objectDefinitionRegistry.registerCustomConfiguration(parentId, customConfiguration);
			}
		}
	}
}
