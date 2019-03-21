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
package org.springextensions.actionscript.ioc.config.impl {

	import flash.errors.IllegalOperationError;

	import org.as3commons.async.operation.IOperation;
	import org.as3commons.lang.IDisposable;
	import org.springextensions.actionscript.ioc.config.IObjectDefinitionsProvider;
	import org.springextensions.actionscript.ioc.config.property.IPropertiesProvider;
	import org.springextensions.actionscript.ioc.config.property.TextFileURI;
	import org.springextensions.actionscript.ioc.config.property.impl.Properties;
	import org.springextensions.actionscript.ioc.objectdefinition.IBaseObjectDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class AbstractObjectDefinitionsProvider implements IObjectDefinitionsProvider, IDisposable {

		private var _objectDefinitions:Object;
		private var _defaultObjectDefinition:IBaseObjectDefinition;
		private var _propertyURIs:Vector.<TextFileURI>;
		private var _propertiesProvider:IPropertiesProvider;
		private var _isDisposed:Boolean;

		/**
		 * Creates a new <code>AbstractObjectDefinitionsProvider</code> instance.
		 */
		public function AbstractObjectDefinitionsProvider(self:AbstractObjectDefinitionsProvider) {
			super();
			if (this !== self) {
				throw new IllegalOperationError("AbstractObjectDefinitionsProvider is abstract and can't be instantiated directly, it can only be extended");
			}
			_propertyURIs = new Vector.<TextFileURI>();
			_objectDefinitions = {};
			_propertiesProvider = new Properties();
			_propertyURIs = new Vector.<TextFileURI>();
		}

		public function createDefinitions():IOperation {
			throw new IllegalOperationError("Not implemented in abstract base class");
		}

		public function get objectDefinitions():Object {
			return _objectDefinitions;
		}

		public function get propertyURIs():Vector.<TextFileURI> {
			return _propertyURIs;
		}

		public function get propertiesProvider():IPropertiesProvider {
			return _propertiesProvider;
		}

		public function get defaultObjectDefinition():IBaseObjectDefinition {
			return _defaultObjectDefinition;
		}

		public function set defaultObjectDefinition(value:IBaseObjectDefinition):void {
			_defaultObjectDefinition = value;
		}

		public function set objectDefinitions(value:Object):void {
			_objectDefinitions = value;
		}

		public function get isDisposed():Boolean {
			return _isDisposed;
		}

		public function dispose():void {
			if (!_isDisposed) {
				_isDisposed = true;
				_propertyURIs = null;
				_objectDefinitions = null;
				_propertiesProvider = null;
				_propertyURIs = null;
			}
		}
	}
}
