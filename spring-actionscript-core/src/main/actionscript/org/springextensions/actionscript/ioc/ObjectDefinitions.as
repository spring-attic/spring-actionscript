/*
* Copyright 2007-2011 the original author or authors.
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
package org.springextensions.actionscript.ioc {

	import flash.system.ApplicationDomain;
	
	import org.springextensions.actionscript.ioc.factory.support.SimpleObjectDefinitionRegistry;

	/**
	 * An object definition registry that contains default settings for the object definiton that
	 * get registered.
	 *
	 * @author Christophe Herreman
	 */
	public class ObjectDefinitions extends SimpleObjectDefinitionRegistry {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new ObjectDefinitions object.
		 */
		public function ObjectDefinitions(applicationDomain:ApplicationDomain) {
			super();
			this.applicationDomain = applicationDomain;
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// defaultInitMethod
		// ----------------------------

		private var _defaultInitMethod:String;

		public function get defaultInitMethod():String {
			return _defaultInitMethod;
		}

		public function set defaultInitMethod(value:String):void {
			if (value !== _defaultInitMethod) {
				_defaultInitMethod = value;
			}
		}

		// ----------------------------
		// defaultLazyInit
		// ----------------------------

		private var _defaultLazyInit:Boolean = false;

		public function get defaultLazyInit():Boolean {
			return _defaultLazyInit;
		}

		public function set defaultLazyInit(value:Boolean):void {
			if (value !== _defaultLazyInit) {
				_defaultLazyInit = value;
			}
		}

		// ----------------------------
		// defaultAutowire
		// ----------------------------

		private var _defaultAutowire:AutowireMode = AutowireMode.NO;

		public function get defaultAutowire():AutowireMode {
			return _defaultAutowire;
		}

		public function set defaultAutowire(value:AutowireMode):void {
			if (value !== _defaultAutowire) {
				_defaultAutowire = value;
			}
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Copies all object definitions from the given registry into this one.
		 *
		 * @param other the registry from which all object definitions will be copied into this one
		 */
		public function merge(other:ObjectDefinitions):void {
			if (!other) {
				return;
			}

			var objectNames:Array = other.objectDefinitionNames;
			for each (var objectName:String in objectNames) {
				registerObjectDefinition(objectName, other.getObjectDefinition(objectName));
			}
		}

	}
}