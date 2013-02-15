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
package org.springextensions.actionscript.context.support.mxml {

	import mx.core.IMXMLObject;

	/**
	 * 
	 * @author Christophe Herreman
	 * @docref container-documentation.html#composing_mxml_based_configuration_metadata
	 */
	public class MXMLObjects implements IMXMLObject {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function MXMLObjects() {
			super();
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

		private var _defaultLazyInit:Boolean;

		public function get defaultLazyInit():Boolean {
			return _defaultLazyInit;
		}

		public function set defaultLazyInit(value:Boolean):void {
			if (value !== _defaultLazyInit) {
				_defaultLazyInit = value;
			}
		}

		// ----------------------------
		// defaultDependencyCheck
		// ----------------------------

		private var _defaultDependencyCheck:String;

		[Inspectable(enumeration="none,simple,objects,all", defaultValue="none")]

		public function get defaultDependencyCheck():String {
			return _defaultDependencyCheck;
		}

		public function set defaultDependencyCheck(value:String):void {
			if (value !== _defaultDependencyCheck) {
				_defaultDependencyCheck = value;
			}
		}

		// ----------------------------
		// defaultAutowire
		// ----------------------------

		private var _defaultAutowire:String;

		[Inspectable(enumeration="no,byName,byType,constructor,autodetect", defaultValue="no")]

		public function get defaultAutowire():String {
			return _defaultAutowire;
		}

		public function set defaultAutowire(value:String):void {
			if (value !== _defaultAutowire) {
				_defaultAutowire = value;
			}
		}

		// --------------------------------------------------------------------
		//
		// Implementation: IMXMLObject
		//
		// --------------------------------------------------------------------

		public function initialized(document:Object, id:String):void {
			trace("ini");
		}
	}
}