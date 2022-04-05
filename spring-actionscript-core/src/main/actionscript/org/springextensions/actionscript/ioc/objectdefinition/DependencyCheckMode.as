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

	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	/**
	 * Enumeration for dependency check modes for object properties.
	 * @author Martino Piccinato
	 * @productionversion SpringActionscript 2.0
	 * @see org.springextensions.actionscript.ioc.IObjectDefinition IObjectDefinition
	 */
	public class DependencyCheckMode {

		/** No dependency check is done on the object properties */
		public static const NONE:DependencyCheckMode = new DependencyCheckMode(NONE_NAME);

		/** Dependency check is done just on primitive and collection object properties */
		public static const SIMPLE:DependencyCheckMode = new DependencyCheckMode(SIMPLE_NAME);

		/** Dependency check is done just on "collaborator" (non primitive and non collection) object
		 * properties */
		public static const OBJECTS:DependencyCheckMode = new DependencyCheckMode(OBJECTS_NAME);

		/** Dependency check is done on all object properties */
		public static const ALL:DependencyCheckMode = new DependencyCheckMode(ALL_NAME);

		/** Autowired values */
		private static const NONE_NAME:String = "none";

		private static const SIMPLE_NAME:String = "simple";

		private static const OBJECTS_NAME:String = "objects";

		private static const ALL_NAME:String = "all";

		private static var _enumCreated:Boolean = false;

		private var _name:String;

		{
			_enumCreated = true;
		}

		/**
		 * Creates a new <code>ObjectDefintionDependencyCheck</code> instance.
		 * This constructor is only used internally to set up the enum and all
		 * calls will fail.
		 *
		 * @param name the name of the scope
		 */
		public function DependencyCheckMode(name:String) {
			Assert.state((false == _enumCreated), "The ObjectDefinitionAutowireDependencyCheck enum has already been created.");
			_name = name;
		}

		/**
		 *
		 */
		public static function fromName(name:String):DependencyCheckMode {
			if (!name) {
				return NONE;
			}

			var result:DependencyCheckMode;

			// check if the name is a valid value in the enum
			switch (StringUtils.trim(name.toUpperCase())) {
				case NONE_NAME.toUpperCase():
					result = NONE;
					break;
				case OBJECTS_NAME.toUpperCase():
					result = OBJECTS;
					break;
				case SIMPLE_NAME.toUpperCase():
					result = SIMPLE;
					break;
				case ALL_NAME.toUpperCase():
					result = ALL;
					break;
				default:
					result = NONE;
			}

			return result;
		}

		/**
		 * Returns the name of the autowire type.
		 *
		 * @returns the name of the autowire type
		 */
		public function get name():String {
			return _name;
		}

		public function toString():String {
			return _name;
		}

		/**
		 * @return <code>true</code> if simple properties should be checked,
		 * <code>false</code> otherwise.
		 */
		public function checkSimpleProperties():Boolean {
			return (this === DependencyCheckMode.ALL || this === DependencyCheckMode.SIMPLE || this === DependencyCheckMode.NONE);
		}

		/**
		 * @return <code>true</code> if object properties should be checked,
		 * <code>false</code> otherwise.
		 */
		public function checkObjectProperties():Boolean {
			return (this === DependencyCheckMode.ALL || this === DependencyCheckMode.OBJECTS || this === DependencyCheckMode.NONE);
		}

	}

}
