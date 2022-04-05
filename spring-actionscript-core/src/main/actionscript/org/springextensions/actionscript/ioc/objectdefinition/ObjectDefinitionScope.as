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
package org.springextensions.actionscript.ioc.objectdefinition {

	import flash.utils.Dictionary;

	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	/**
	 * Enumeration for the scopes of an object definition.
	 * @author Christophe Herreman
	 * @productionversion SpringActionscript 2.0
	 */
	public final class ObjectDefinitionScope {

		private static const TYPES:Dictionary = new Dictionary();

		/**
		 * Multiple instances of the specified object can exist
		 */
		public static const PROTOTYPE:ObjectDefinitionScope = new ObjectDefinitionScope(PROTOTYPE_NAME);
		/**
		 * Only one instance of the specified object can exist
		 */
		public static const SINGLETON:ObjectDefinitionScope = new ObjectDefinitionScope(SINGLETON_NAME);
		/**
		 * The specified object is a stage component
		 */
		public static const STAGE:ObjectDefinitionScope = new ObjectDefinitionScope(STAGE_NAME);
		/**
		 * The specified object is created remotely
		 */
		public static const REMOTE:ObjectDefinitionScope = new ObjectDefinitionScope(REMOTE_NAME);

		private static const PROTOTYPE_NAME:String = "prototype";
		private static const SINGLETON_NAME:String = "singleton";
		private static const STAGE_NAME:String = "stage";
		private static const REMOTE_NAME:String = "remote";

		private static var _enumCreated:Boolean = false;

		private var _name:String;
		{
			_enumCreated = true;
		}

		/**
		 * Creates a new ObjectDefintionScope object.
		 * This constructor is only used internally to set up the enum and all
		 * calls will fail.
		 * @param name the name of the scope
		 */
		public function ObjectDefinitionScope(name:String) {
			Assert.state(!_enumCreated, "The ObjectDefinitionScope enum has already been created.");
			_name = name;
			TYPES[_name] = this;
		}

		/**
		 *
		 */
		public static function fromName(name:String):ObjectDefinitionScope {
			return TYPES[StringUtils.trim(name.toLowerCase())];
		}

		/**
		 * Returns the name of the scope.
		 */
		public function get name():String {
			return _name;
		}

		public function toString():String {
			return _name;
		}
	}
}
