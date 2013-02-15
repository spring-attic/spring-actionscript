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
package org.springextensions.actionscript.ioc {
	
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;
	
	/**
	 * Enumeration for the scopes of an object definition.
	 *
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 * @docref container-documentation.html#object_scopes
	 */
	public final class ObjectDefinitionScope {
		
		public static const PROTOTYPE:ObjectDefinitionScope = new ObjectDefinitionScope(PROTOTYPE_NAME);
		
		public static const SINGLETON:ObjectDefinitionScope = new ObjectDefinitionScope(SINGLETON_NAME);
		
		//TODO: RZ: stage scope is no longer relevant, please confirm
		//public static const STAGE:ObjectDefinitionScope = new ObjectDefinitionScope(STAGE_NAME);
		
		public static const PROTOTYPE_NAME:String = "prototype";
		
		public static const SINGLETON_NAME:String = "singleton";
		
		//public static const STAGE_NAME:String = "stage";
		
		private static var _enumCreated:Boolean = false;
		
		private var _name:String;
		{
			_enumCreated = true;
		}
		
		/**
		 * Creates a new ObjectDefintionScope object.
		 * This constructor is only used internally to set up the enum and all
		 * calls will fail.
		 *
		 * @param name the name of the scope
		 */
		public function ObjectDefinitionScope(name:String) {
			Assert.state(!_enumCreated, "The ObjectDefinitionScope enum has already been created.");
			_name = name;
		}
		
		/**
		 *
		 */
		public static function fromName(name:String):ObjectDefinitionScope {
			var result:ObjectDefinitionScope;
			
			// check if the name is a valid value in the enum
			switch (StringUtils.trim(name.toLowerCase())) {
				case PROTOTYPE_NAME:
					result = PROTOTYPE;
					break;
				case SINGLETON_NAME:
					result = SINGLETON;
					break;
				/*case STAGE_NAME:
					result = STAGE;
					break;*/
				default:
					result = SINGLETON;
			}
			return result;
		}
		
		/**
		 * Returns the name of the scope.
		 *
		 * @returns the name of the scope
		 */
		public function get name():String {
			return _name;
		}
		
		public function toString():String {
			return _name;
		}
	}
}
