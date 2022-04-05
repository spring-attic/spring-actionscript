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
package org.springextensions.actionscript.ioc.impl {

	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import org.as3commons.lang.IDisposable;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.metadata.registry.IMetadataProcessorRegistry;
	import org.as3commons.metadata.registry.impl.AS3ReflectMetadataProcessorRegistry;
	import org.as3commons.reflect.MethodInvoker;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContextAware;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistryAware;
	import org.springextensions.actionscript.ioc.IObjectDestroyer;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistryAware;
	import org.springextensions.actionscript.ioc.objectdefinition.ObjectDefinitionScope;
import org.springextensions.actionscript.ioc.objectdefinition.impl.ArgumentDefinition;
import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinition;
	import org.springextensions.actionscript.util.ContextUtils;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class DefaultObjectDestroyer implements IObjectDestroyer, IApplicationContextAware, IDisposable {

		private var _metadataProcessorRegistry:IMetadataProcessorRegistry;
		private var _managedObjects:Dictionary;
		private var _isDisposed:Boolean;
		private var _applicationContext:IApplicationContext;
		private static const NAMELESS:String = "nameless_object";

		private static var logger:ILogger = getClassLogger(DefaultObjectDestroyer);

		/**
		 * Creates a new <code>DefaultObjectDestroyer</code> instance.
		 */
		public function DefaultObjectDestroyer(context:IApplicationContext) {
			super();
			_managedObjects = new Dictionary(true);
			_applicationContext = context;
		}

		public function get metadataProcessorRegistry():IMetadataProcessorRegistry {
			return _metadataProcessorRegistry ||= new AS3ReflectMetadataProcessorRegistry();
		}

		public function set metadataProcessorRegistry(value:IMetadataProcessorRegistry):void {
			_metadataProcessorRegistry = value;
		}

		public function get eventBusUserRegistry():IEventBusUserRegistry {
			return (_applicationContext is IEventBusUserRegistryAware) ? IEventBusUserRegistryAware(_applicationContext).eventBusUserRegistry : null;
		}

		public function set eventBusUserRegistry(value:IEventBusUserRegistry):void {
			//not used
		}

		public function destroy(instance:Object):void {
			if (_managedObjects[instance] == null) {
				logger.debug("Unregistered instance {0}, ignoring it.", [instance]);
				return;
			}
			ContextUtils.disposeInstance(instance);
			var objectName:String = _managedObjects[instance];
			delete _managedObjects[instance];
			objectName = (objectName == NAMELESS) ? null : objectName;

			metadataProcessorRegistry.process(instance, [objectName]);

			eventBusUserRegistry.clearAllProxyRegistrations(instance);

			if (instance is IEventDispatcher) {
				eventBusUserRegistry.removeEventListeners(instance as IEventDispatcher);
			}

			if ((objectName != null) && (_applicationContext.objectDefinitionRegistry.containsObjectDefinition(objectName))) {
				var definition:IObjectDefinition = _applicationContext.objectDefinitionRegistry.getObjectDefinition(objectName);
				if (StringUtils.hasText(definition.destroyMethod)) {
					logger.debug("Invoking destroy method '{0}()' on instance {1}", [definition.destroyMethod, instance]);
					var mi:MethodInvoker = new MethodInvoker();
					mi.target = instance;
					mi.method = definition.destroyMethod;
					mi.invoke();
				}
				var referenceName:String;
				var property:PropertyDefinition;

				for each (property in definition.properties) {
					var valueDefinition:ArgumentDefinition = property.valueDefinition;
					if (valueDefinition && valueDefinition.ref) {
						referenceName = valueDefinition.ref.objectName;
						if (_applicationContext.objectDefinitionRegistry.containsObjectDefinition(referenceName)) {
							if (_applicationContext.objectDefinitionRegistry.getObjectDefinition(referenceName).scope === ObjectDefinitionScope.PROTOTYPE) {
								destroy(instance[property.qName]);
								logger.debug("property '{0}' value is a reference and prototype scoped, destroyed the reference: {1}", [property.qName, instance[property.qName]]);
							}
						}
					}
					instance[property.qName] = null;
					logger.debug("Nulled property '{0}' on instance {1}", [property.qName, instance]);
				}
			}
			logger.debug("Destroyed instance {0}", [instance]);
		}

		public function registerInstance(instance:Object, objectName:String=null):void {
			if (instance != null) {
				objectName ||= NAMELESS;
				logger.debug("Registered instance {0} with name {1}", [instance, objectName]);
				_managedObjects[instance] = objectName;
			}
		}

		public function get isDisposed():Boolean {
			return _isDisposed;
		}

		public function dispose():void {
			if (!_isDisposed) {
				_isDisposed = true;
				_managedObjects = null;
				ContextUtils.disposeInstance(_metadataProcessorRegistry);
				_metadataProcessorRegistry = null;
				_applicationContext = null;
				logger.debug("{0} has been disposed...", [this]);
			}
		}

		public function get applicationContext():IApplicationContext {
			return _applicationContext;
		}

		public function set applicationContext(value:IApplicationContext):void {
			_applicationContext = value;
		}
	}
}
