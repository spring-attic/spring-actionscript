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
package org.springextensions.actionscript.ioc.autowire {

	import flash.utils.Dictionary;

	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	/**
	 * Enumeration for the autowire types of an object definition.
	 * @author Martino Piccinato
	 * @author Christophe Herreman
	 * @productionversion SpringActionscript 2.0
	 * @see org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition
	 */
	public class AutowireMode {

		private static const TYPES:Dictionary = new Dictionary();

		/** No autowire on the object */
		public static const NO:AutowireMode = new AutowireMode(NO_NAME);

		/** Autowire unclaimed non simple properties with object having the same name of the properties */
		public static const BYNAME:AutowireMode = new AutowireMode(BYNAME_NAME);

		/** Autowire unclaimed non simple properties with objects having the same type */
		public static const BYTYPE:AutowireMode = new AutowireMode(BYTYPE_NAME);

		/** Autowire constructor arguments with objects having the same type */
		public static const CONSTRUCTOR:AutowireMode = new AutowireMode(CONSTRUCTOR_NAME);

		/** Autowire by constructor or by type depending whether there is a constructor with arguments or not */
		public static const AUTODETECT:AutowireMode = new AutowireMode(AUTODETECT_NAME);

		/** Autowired values */
		private static const NO_NAME:String = "no";
		private static const BYNAME_NAME:String = "byName";
		private static const BYTYPE_NAME:String = "byType";
		private static const CONSTRUCTOR_NAME:String = "constructor";
		private static const AUTODETECT_NAME:String = "autodetect";
		private static const ALREADY_CREATED_ERROR:String = "The AutowireMode enum has already been created.";

		private static var _enumCreated:Boolean = false;

		private var _name:String;

		{
			_enumCreated = true;
		}

		/**
		 * Creates a new ObjectDefintionAutowire object.
		 * This constructor is only used internally to set up the enum and all
		 * calls will fail.
		 *
		 * @param name the name of the scope
		 */
		public function AutowireMode(name:String) {
			Assert.state(!_enumCreated, ALREADY_CREATED_ERROR);
			_name = name;
			TYPES[_name.toLowerCase()] = this;
		}

		/**
		 *
		 */
		public static function fromName(name:String):AutowireMode {
			if (!StringUtils.hasText(name)) {
				return NO;
			}
			name = name.toLowerCase();
			return (TYPES[name] != null) ? TYPES[name] : NO;
		}

		/**
		 * Returns the name of the autowire type.
		 */
		public function get name():String {
			return _name;
		}

		/**
		 *
		 */
		public function toString():String {
			return _name;
		}

	}

}
