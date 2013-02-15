/*
 * Copyright 2007-2010 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springextensions.actionscript.ioc.factory.support {
	
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassNotFoundError;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.ObjectUtils;
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.ObjectContainerError;
	import org.springextensions.actionscript.ioc.factory.IFactoryObject;
	import org.springextensions.actionscript.ioc.factory.NoSuchObjectDefinitionError;
	import org.springextensions.actionscript.ioc.factory.ObjectDefinitionStoreError;
	import org.springextensions.actionscript.ioc.factory.config.IConfigurableListableObjectFactory;
	
	/**
	 * Default implementation of the IConfigurableListableObjectFactory and
	 * the IObjectDefinitionRegistry interfaces.
	 *
	 * @author Christophe Herreman
	 * @author Roland Zwaga
	 * @docref container-documentation.html#instantiating_a_container
	 */
	public class DefaultListableObjectFactory extends AbstractObjectFactory implements IConfigurableListableObjectFactory, IObjectDefinitionRegistry {
		
		private static const LOGGER:ILogger = LoggerFactory.getClassLogger(DefaultListableObjectFactory);
		
		/**
		 * Constructs a new <code>DefaultListableObjectFactory</code> instance.
		 */
		public function DefaultListableObjectFactory() {
			super();
		}
		
		/**
		 * Set whether it should be allowed to override object definitions by registering
		 * a different definition with the same name, automatically replacing the former.
		 * If not, an error will be thrown.
		 *
		 * @see #registerObjectDefinition
		 * @default true
		 */
		public function set allowObjectDefinitionOverriding(value:Boolean):void {
			_allowBeanDefinitionOverriding = value;
		}
		
		// ====================================================================
		// IListableObjectFactory implementation
		// ====================================================================

		private var _allowBeanDefinitionOverriding:Boolean = true;

		/**
		 * @inheritDoc
		 */
		public function get numObjectDefinitions():uint {
			return ObjectUtils.getNumProperties(objectDefinitions);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get objectDefinitionNames():Array {
			return ObjectUtils.getKeys(objectDefinitions);
		}
		
		/**
		 * @throws org.springextensions.actionscript.errors.ObjectContainerError if the class for the specified <code>ObjectDefinition</code> isn't found
		 * @inheritDoc
		 */
		public function getObjectNamesForType(type:Class):Array {
			var result:Array = [];
			var objectDefinition:IObjectDefinition;

			// scan object definitions
			for (var key:String in objectDefinitions) {
				objectDefinition = objectDefinitions[key];
				
				try	{
					var cls:Class = getClassForName(objectDefinition.className);
					if (cls == null) {
						throw new ClassNotFoundError();
					}
					if (ClassUtils.isAssignableFrom(type, cls, applicationDomain)) {
						result.push(key);
					}
				}
				catch(e:ClassNotFoundError){
					throw new ObjectContainerError(e.message);
				}
			}

			// scan explicit singletons
			for (var singletonName:String in explicitSingletonCache) {
				if (explicitSingletonCache[singletonName] is type) {
					result.push(singletonName);
				}
			}

			return result;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getObjectDefinitionsOfType(type:Class):Array {
			Assert.notNull(type,"The type argument must not be null");
			var result:Array = [];
			var objectDefinition:IObjectDefinition;
			
			for (var key:String in objectDefinitions) {
				objectDefinition = objectDefinitions[key];
				
				if (ClassUtils.isAssignableFrom(type, getClassForName(objectDefinition.className), applicationDomain)) {
					result[result.length] = objectDefinitions[key];
				}
			}
			return result;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getObjectsOfType(type:Class):Object {
			Assert.notNull(type,"The type argument must not be null");
			var result:Object = {};
			var objectDefinition:IObjectDefinition;

			// scan object definitions
			for (var key:String in objectDefinitions) {
				objectDefinition = objectDefinitions[key];
				
				if (ClassUtils.isAssignableFrom(type, getClassForName(objectDefinition.className), applicationDomain)) {
					result[key] = objectDefinitions[key];
				}
			}

			// scan explicit singletons
			for (var singletonName:String in explicitSingletonCache) {
				if (explicitSingletonCache[singletonName] is type) {
					result[singletonName] = explicitSingletonCache[singletonName];
				}
			}

			return result;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getUsedTypes():Array {
			var result:Array = [];
			var objectDefinition:IObjectDefinition;
			
			for (var key:String in objectDefinitions) {
				objectDefinition = objectDefinitions[key];
				var type:Class = ClassUtils.forName(objectDefinition.className, applicationDomain);
				if (result.indexOf(type) < 0) {
					result[result.length] = type;
				}
			}
			
			return result;
		}
		
		// ====================================================================
		// IConfigurableListableObjectFactory implementation
		// ====================================================================
		
		/**
		 * <p>Checks if the objectdefinition is an implementation of <code>IFactoryObject</code>, if so
		 * the factory will be pre-instantiated, not the result of the factory.</p>
		 * @inheritDoc
		 */
		public function preInstantiateSingletons():void {
			preInstantiateSingletonsWithObjectDefinition();
			wireExplicitSingletons();
		}

		protected function preInstantiateSingletonsWithObjectDefinition():void {
			var singletons:Array = [];

			for (var objectName:String in objectDefinitions) {
				var objectDefinition:IObjectDefinition = objectDefinitions[objectName];

				if (objectDefinition.isSingleton && !objectDefinition.isLazyInit) {
					var clazz:Class = getClassForName(objectDefinition.className);
					if (ClassUtils.isImplementationOf(clazz, IFactoryObject, applicationDomain)) {
						singletons.push(OBJECT_FACTORY_PREFIX + objectName);
					} else {
						singletons.push(objectName);
					}
				}
			}

			LOGGER.info("Pre-instantiating '{0}' singletons in '{1}': {2}", singletons.length, this, singletons);

			for each (var singletonName:String in singletons) {
				getObject(singletonName);
				LOGGER.debug("Singleton instantiated: '{0}'", singletonName);
			}
		}

		protected function wireExplicitSingletons():void {
			var explicitSingletonNames:Array = this.explicitSingletonNames;

			LOGGER.info("Wiring '{0}' explicit singletons in '{1}': {2}", explicitSingletonNames.length, this, explicitSingletonNames);

			for each (var explicitSingletonName:String in explicitSingletonNames) {
				wire(explicitSingletonCache[explicitSingletonName], null, explicitSingletonName);
				LOGGER.debug("Explicit singleton wired: '{0}'", explicitSingletonName);
			}
		}

		// ====================================================================
		// IObjectDefinitionRegistry implementation
		// ====================================================================
		/**
		 * @inheritDoc
		 */
		public function registerObjectDefinition(objectName:String, objectDefinition:IObjectDefinition):void {
			Assert.hasText(objectName, "objectName must have text");
			Assert.notNull(objectDefinition, "objectDefinition must not be null");
			
			var oldObjectDefinition:IObjectDefinition = objectDefinitions[objectName];
			
			if (oldObjectDefinition) {
				if (_allowBeanDefinitionOverriding) {
//					if (logger.infoEnabled) {
						LOGGER.info("Overriding object definition for object '{0}': replacing [{1}] with [{2}]", objectName, oldObjectDefinition, objectDefinition);
	//				}
					// remove all instances of the object we are about to override
					clearObjectFromInternalCache(objectName);
				} else {
					throw new ObjectDefinitionStoreError("Cannot register object definition [" + objectDefinition + "] for object '" + objectName + "': There is already [" + oldObjectDefinition + "] bound.", objectName);
				}
			}
			
			objectDefinitions[objectName] = objectDefinition;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeObjectDefinition(objectName:String):void {
			delete objectDefinitions[objectName];
		}
		
		/**
		 * @inheritDoc
		 */
		public function containsObjectDefinition(objectName:String):Boolean {
			return Boolean(objectDefinitions[objectName] as IObjectDefinition);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getObjectDefinition(objectName:String):IObjectDefinition {
			var result:IObjectDefinition = objectDefinitions[objectName];
			
			if (result == null) {
				throw new NoSuchObjectDefinitionError(objectName);
			}
			return result;
		}
	
	}
}
