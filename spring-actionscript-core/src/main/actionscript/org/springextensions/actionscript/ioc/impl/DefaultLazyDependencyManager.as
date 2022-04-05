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
package org.springextensions.actionscript.ioc.impl {
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import org.as3commons.lang.IDisposable;
	import org.as3commons.lang.SoftReference;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.ILazyDependencyManager;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.event.ObjectFactoryEvent;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.event.ObjectDefinitionEvent;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class DefaultLazyDependencyManager extends EventDispatcher implements ILazyDependencyManager, IDisposable {

		private static var logger:ILogger = getClassLogger(DefaultLazyDependencyManager);

		/**
		 * Creates a new <code>DefaultLazyDependencyManager</code> instance.
		 */
		public function DefaultLazyDependencyManager(factory:IObjectFactory) {
			super();
			_registrations = {};
			factory.addEventListener(ObjectFactoryEvent.OBJECT_WIRED, onObjectWired, false, 0, true);
			_objectFactory = factory;
		}

		private var _isDisposed:Boolean;
		private var _registrations:Object;
		private var _objectFactory:IObjectFactory;

		public function get isDisposed():Boolean {
			return _isDisposed;
		}

		public function dispose():void {
			if (!_isDisposed) {
				_isDisposed = true;
				for (var name:String in _registrations) {
					(_registrations[name] as IDisposable).dispose();
					delete _registrations[name];
				}
				_registrations = null;
			}
		}

		public function registerLazyInjection(objectName:String, property:PropertyDefinition, instance:*):void {
			var ref:RuntimeObjectReference = property.valueDefinition.ref;
			if (ref != null) {
				var lookup:Object = _registrations[ref.objectName] ||= createNewLookup(objectName, property);
				lookup[objectName] ||= new Dictionary(true);
				var registration:LazyDependencyRegistration = lookup[objectName][property] ||= new LazyDependencyRegistration(property.qName);
				registration.addInstance(instance);
				logger.debug("Registered lazy dependency '{0}' for instance {1} with id '{2}'", [ref.objectName, instance, objectName]);
			}
		}

		public function updateInjections(dependencyName:String, dependencyInstance:*):void {
			var lookup:Object = _registrations[dependencyName];
			if (lookup != null) {
				for (var objectName:String in lookup) {
					var propertyLookup:Dictionary = lookup[objectName];
					lookup[objectName] = null;
					var instances:Vector.<Object> = new Vector.<Object>();
					for (var property:* in propertyLookup) {
						var registration:LazyDependencyRegistration = propertyLookup[property];
						for each (var ref:SoftReference in registration.instances) {
							var instance:* = ref.value;
							if (instance != null) {
								instances[instances.length] = instance;
								instance[registration.propertyName] = dependencyInstance;
								logger.debug("Injected lazy dependency '{0}' on property '{1}' on instance {2} with value {3}", [dependencyName, property.qName, instance, dependencyInstance]);
							}
						}
					}
					registration.dispose();
					var definition:IObjectDefinition = _objectFactory.objectDefinitionRegistry.getObjectDefinition(objectName);
					definition.dispatchEvent(new ObjectDefinitionEvent(ObjectDefinitionEvent.INSTANCES_DEPENDENCIES_UPDATED, definition, instances));
				}
				delete _registrations[dependencyName];
			}
		}

		private function createNewLookup(objectName:String, property:PropertyDefinition):Object {
			var result:Object = {};
			var propDictionary:Dictionary = new Dictionary(true);
			result[objectName] = propDictionary;
			propDictionary[property] = new LazyDependencyRegistration(property.qName);
			return result;
		}

		private function onObjectWired(event:ObjectFactoryEvent):void {
			updateInjections(event.objectName, event.objectInstance);
		}
	}

}

import org.as3commons.lang.IDisposable;
import org.as3commons.lang.SoftReference;

internal class LazyDependencyRegistration implements IDisposable {

	public function LazyDependencyRegistration(prop:QName) {
		super();
		_instances = new Vector.<SoftReference>();
		_propertyName = prop;
	}

	private var _instances:Vector.<SoftReference>;
	private var _isDisposed:Boolean;
	private var _propertyName:QName;

	public function get instances():Vector.<SoftReference> {
		return _instances;
	}

	public function get isDisposed():Boolean {
		return _isDisposed;
	}

	public function get propertyName():QName {
		return _propertyName;
	}

	public function addInstance(instance:*):void {
		_instances[_instances.length] = new SoftReference(instance);
	}

	public function dispose():void {
		if (!_isDisposed) {
			_isDisposed = true;
			_propertyName = null;
			_instances = null;
		}
	}
}
