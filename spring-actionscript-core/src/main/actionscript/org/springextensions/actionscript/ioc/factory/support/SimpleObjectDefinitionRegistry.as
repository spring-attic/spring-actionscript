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

	import flash.system.ApplicationDomain;
	
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.ObjectUtils;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.ObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.IApplicationDomainAware;
	import org.springextensions.actionscript.ioc.factory.NoSuchObjectDefinitionError;

	/**
	 * Basic implementation of the <code>IObjectDefinitionRegistry</code> interface.
	 *
	 * @author Christophe Herreman
	 */
	public class SimpleObjectDefinitionRegistry implements IObjectDefinitionRegistry, IApplicationDomainAware {

		/** The registered object definitions. */
		private var _objectDefinitions:Object = {};

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>SimpleObjectDefinitionRegistry</code> instance.
		 */
		public function SimpleObjectDefinitionRegistry() {
			super();
		}
		
		private var _applicationDomain:ApplicationDomain;
		public function get applicationDomain():ApplicationDomain {
			return _applicationDomain;
		}
		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
		}

		// --------------------------------------------------------------------
		//
		// Implementation: IObjectDefinitionRegistry
		//
		// --------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public function get objectDefinitionNames():Array {
			return ObjectUtils.getKeys(_objectDefinitions);
		}

		/**
		 * @inheritDoc
		 */
		public function get numObjectDefinitions():uint {
			return ObjectUtils.getNumProperties(_objectDefinitions);
		}

		/**
		 * @inheritDoc
		 */
		public function registerObjectDefinition(objectName:String, objectDefinition:IObjectDefinition):void {
			Assert.hasText(objectName, "'objectName' must not be empty or null");
			Assert.notNull(objectDefinition, "'objectDefinition' must not be null");
			_objectDefinitions[objectName] = objectDefinition;
		}

		/**
		 * @inheritDoc
		 */
		public function removeObjectDefinition(objectName:String):void {
			delete _objectDefinitions[objectName];
		}

		/**
		 * @inheritDoc
		 */
		public function getObjectDefinition(objectName:String):IObjectDefinition {
			var result:ObjectDefinition = _objectDefinitions[objectName];
			if (!result) {
				throw new NoSuchObjectDefinitionError(objectName);
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function containsObjectDefinition(objectName:String):Boolean {
			return (_objectDefinitions[objectName]);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getObjectDefinitionsOfType(type:Class):Array {
			Assert.notNull(type,"The type argument must not be null");
			var result:Array = [];
			var objectDefinition:IObjectDefinition;
			
			for (var key:String in _objectDefinitions) {
				objectDefinition = _objectDefinitions[key];
				
				if (ClassUtils.isAssignableFrom(type, ClassUtils.forName(objectDefinition.className, _applicationDomain), _applicationDomain)) {
					result[result.length] = _objectDefinitions[key];
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
			
			for (var key:String in _objectDefinitions) {
				objectDefinition = _objectDefinitions[key];
				var type:Class = ClassUtils.forName(objectDefinition.className, _applicationDomain);
				if (result.indexOf(type) < 0) {
					result[result.length] = type;
				}
			}
			
			return result;
		}

	}
}