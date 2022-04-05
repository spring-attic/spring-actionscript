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
package org.springextensions.actionscript.ioc.config.impl.mxml {
	import org.as3commons.async.operation.IOperation;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.Field;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.Variable;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContextAware;
	import org.springextensions.actionscript.ioc.config.IObjectDefinitionsProvider;
	import org.springextensions.actionscript.ioc.config.impl.AbstractObjectDefinitionsProvider;
	import org.springextensions.actionscript.ioc.config.impl.mxml.component.MXMLObjectDefinition;
	import org.springextensions.actionscript.ioc.config.impl.mxml.component.PropertyPlaceholder;
	import org.springextensions.actionscript.ioc.config.impl.mxml.component.SASObjects;
	import org.springextensions.actionscript.ioc.objectdefinition.IBaseObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class MXMLObjectDefinitionsProvider extends AbstractObjectDefinitionsProvider implements IObjectDefinitionsProvider, IApplicationContextAware {
		private static const UNDERSCORE_CHAR:String = "_";
		private static var logger:ILogger = getClassLogger(MXMLObjectDefinitionsProvider);

		/**
		 * Creates a new <code>MXMLObjectDefinitionsProvider</code> instance.
		 */
		public function MXMLObjectDefinitionsProvider() {
			super(this);
		}

		private var _applicationContext:IApplicationContext;

		/**
		 * @inheritDoc
		 */
		public function get applicationContext():IApplicationContext {
			return _applicationContext;
		}

		/**
		 * @private
		 */
		public function set applicationContext(value:IApplicationContext):void {
			_applicationContext = value;
		}
		private var _configurations:Vector.<Class>;


		public function get configurations():Vector.<Class> {
			return _configurations;
		}

		/**
		 *
		 * @param clazz
		 */
		public function addConfiguration(clazz:Class):void {
			_configurations ||= new Vector.<Class>();
			if (_configurations.indexOf(clazz) < 0) {
				_configurations[_configurations.length] = clazz;
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function createDefinitions():IOperation {
			for each (var cls:Class in _configurations) {
				createDefinitionsFromConfigClass(cls);
			}
			return null;
		}

		/**
		 * @inheritDoc
		 */
		override public function dispose():void {
			if (!isDisposed) {
				super.dispose();
				_applicationContext = null;
				_configurations = null;
				defaultObjectDefinition = null;
				logger.debug("Instance {0} has been disposed", [this]);
			}
		}

		private function createDefinitionsFromConfigClass(cls:Class):void {
			var instance:* = new cls();
			if (instance is SASObjects) {
				extractObjectDefinitionsFromConfigInstance(instance, instance.getDefaultDefinition());
				instance.dispose();
			}
		}

		private function extractObjectDefinitionsFromConfigInstance(config:SASObjects, defaultDefinition:IBaseObjectDefinition):void {
			var type:Type = Type.forInstance(config, _applicationContext.applicationDomain);

			// parse accessors = definitions that have an id
			for each (var accessor:Accessor in type.accessors) {
				// an accessor is only valid if:
				// - it is readable
				// - it is writable
				// - its declaring class is not SASObjects: we don't want to parse the "defaultLazyInit" property, etc
				if (accessor.readable && accessor.writeable && (accessor.declaringType === type)) {
					parseObjectDefinition(objectDefinitions, config, accessor, defaultDefinition);
				}
			}

			// parse variables = definitions that don't have an id (name)
			for each (var variable:Variable in type.variables) {
				// a variable is only valid if:
				// - its (generated) id/name matches the pattern '_{CONTEXT_CLASS}_{VARIABLE_CLASS}{N}'
				if ((variable.declaringType === type) && (!StringUtils.hasText(variable.namespaceURI))) {
					parseObjectDefinition(objectDefinitions, config, variable, defaultDefinition);
				}
			}
		}

		private function parseObjectDefinition(definitions:Object, config:Object, field:Field, defaultDefinition:IBaseObjectDefinition):void {
			var result:IObjectDefinition;
			var instance:* = config[field.name];

			if (instance is ICustomObjectDefinitionComponent) {
				var custom:ICustomObjectDefinitionComponent = instance;
				custom.execute(applicationContext, objectDefinitions, defaultDefinition);
				logger.debug("Instance {0}:{1} is ICustomObjectDefinitionComponent, executed it", [field.name, custom]);
			} else if (instance is MXMLObjectDefinition) {
				var mxmlDefinition:MXMLObjectDefinition = instance;
				mxmlDefinition.initializeComponent(_applicationContext, defaultDefinition);
				objectDefinitions[field.name] = mxmlDefinition.definition;
				for (var name:String in mxmlDefinition.objectDefinitions) {
					objectDefinitions[name] = mxmlDefinition.objectDefinitions[name];
				}
				logger.debug("Instance {0}:{1} is MXMLObjectDefinition, executed it", [field.name, mxmlDefinition]);
			} else if (instance is PropertyPlaceholder) {
				propertyURIs[propertyURIs.length] = PropertyPlaceholder(instance).toTextFileURI();
				logger.debug("Instance {0}:{1} is PropertyPlaceholder, converted it to TextFileURI and added it to the list", [field.name, instance]);
			} else if (instance is SASObjects) {
				extractObjectDefinitionsFromConfigInstance(instance, instance.getDefaultDefinition());
				logger.debug("Instance {0}:{1} is SASObjects, extracted definitions from it", [field.name, instance]);
			} else if (!(instance is ISpringConfigurationComponent)) {
				// register a singleton for an explicit config object defined in mxml
				// for instance: <mx:RemoteObject/>,
				// or just a simple public property set to an object instance: public var myComplexSingleton:ComplexClass = new ComplexClass();
				_applicationContext.cache.putInstance(field.name, instance);
				logger.debug("Instance {0}:{1} is an explicit singleton, added it to the application context cache", [field.name, instance]);
			}
		}
	}
}
