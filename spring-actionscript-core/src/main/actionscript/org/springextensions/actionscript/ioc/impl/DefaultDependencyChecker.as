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

	import flash.system.ApplicationDomain;

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.reflect.Field;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.IDependencyChecker;
	import org.springextensions.actionscript.ioc.ILazyDependencyManager;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.error.UnsatisfiedDependencyError;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinition;
	import org.springextensions.actionscript.util.TypeUtils;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class DefaultDependencyChecker implements IDependencyChecker {

		private static var logger:ILogger = getClassLogger(DefaultDependencyChecker);

		private var _lazyDependencyManager:ILazyDependencyManager;
		private var _objectFactory:IObjectFactory;

		public function get lazyDependencyManager():ILazyDependencyManager {
			return _lazyDependencyManager ||= new DefaultLazyDependencyManager(_objectFactory);
		}

		public function set lazyDependencyManager(value:ILazyDependencyManager):void {
			_lazyDependencyManager = value;
		}

		/**
		 * Creates a new <code>DefaultDependencyChecker</code> instance.
		 */
		public function DefaultDependencyChecker(factory:IObjectFactory) {
			super();
			_objectFactory = factory;
		}

		/**
		 *
		 * @param objectDefinition
		 * @param instance
		 * @param objectName
		 * @param applicationDomain
		 * @param throwError
		 * @return
		 */
		public function checkDependenciesSatisfied(objectDefinition:IObjectDefinition, instance:*, objectName:String, applicationDomain:ApplicationDomain, throwError:Boolean=true):LazyDependencyCheckResult {
			logger.debug("Checking all dependencies for instance {0}", [instance]);
			var result:LazyDependencyCheckResult = ((objectDefinition.properties == null) || (objectDefinition.properties.length == 0)) ? LazyDependencyCheckResult.SATISFIED : null;
			for each (var property:PropertyDefinition in objectDefinition.properties) {
				var isNull:Boolean = true;
				try {
					if (!property.isStatic) {
						isNull = (instance[property.qName] == null);
					} else {
						isNull = ((objectDefinition.clazz)[property.qName] == null);
					}
				} catch (e:Error) {
				}

				if ((!property.isSimple) && (property.isLazy) && (isNull) && (property.valueDefinition.ref is RuntimeObjectReference)) {
					lazyDependencyManager.registerLazyInjection(objectName, property, instance);
					if ((result == null) || (LazyDependencyCheckResult.UNSATISFIED)) {
						result = LazyDependencyCheckResult.UNSATISFIED_LAZY;
					}
				} else {
					var unSatisfied:Boolean = (isNull && //
						(property.isSimple && objectDefinition.dependencyCheck.checkSimpleProperties() || //
						(!property.isSimple && objectDefinition.dependencyCheck.checkObjectProperties())) //
						);

					if ((unSatisfied) && (throwError)) {
						throw new UnsatisfiedDependencyError(objectName, property.qName.toString());
					} else if ((unSatisfied) && (!throwError)) {
						logger.debug("Field '{0}' on object '{1}' was not injected, no error thrown", [property.qName, objectName]);
						if (result == null) {
							result = LazyDependencyCheckResult.UNSATISFIED;
						}
					}
				}
			}
			return (result != null) ? result : LazyDependencyCheckResult.SATISFIED;
		}

		public function checkLazyDependencies(objectDefinition:IObjectDefinition, instance:*, applicationDomain:ApplicationDomain):Boolean {
			logger.debug("Checking lazy dependencies for instance {0}", [instance]);
			for each (var property:PropertyDefinition in objectDefinition.properties) {
				if (!property.isLazy) {
					continue;
				}
				var isNull:Boolean = true;
				try {
					if (!property.isStatic) {
						isNull = (instance[property.qName] == null);
					} else {
						isNull = ((objectDefinition.clazz)[property.qName] == null);
					}
				} catch (e:Error) {
				}
				if (isNull) {
					return false;
				}
			}
			return true;
		}

	}
}
