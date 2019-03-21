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
package org.springextensions.actionscript.security {
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	/**
	 * Determines the way access to a stage component is restricted.
	 * @author Roland Zwaga
	 * @sampleref security
	 * @docref container-documentation.html#the_simplesecuritystageprocessor_class
	 */
	public final class AccessStrategy {

		/**
		 * Determines that the <code>editable</code> property will be used to restrict access to a component.
		 */
		public static const EDITABLE:AccessStrategy = new AccessStrategy(EDITABLE_NAME);

		/**
		 * Determines that the <code>enabled</code> property will be used to restrict access to a component.
		 */
		public static const ENABLED:AccessStrategy = new AccessStrategy(ENABLED_NAME);

		/**
		 * Determines that the <code>visible</code> and <code>includeInLayout</code> properties will be used to restrict access to a component.
		 */
		public static const HIDE:AccessStrategy = new AccessStrategy(HIDE_NAME);

		/**
		 * Determines that the <code>visible</code> property will be used to restrict access to a component.
		 */
		public static const VISIBLE:AccessStrategy = new AccessStrategy(VISIBLE_NAME);

		private static const EDITABLE_NAME:String = "editable";
		private static const ENABLED_NAME:String = "enabled";
		private static const HIDE_NAME:String = "hide";
		private static const VISIBLE_NAME:String = "visible";
		private static var _enumCreated:Boolean = false;

		/**
		 * Retunrs a <code>AccessStrategy</code> if an instance with the specified name exists.
		 */
		public static function fromName(name:String):AccessStrategy {
			var result:AccessStrategy;

			// check if the name is a valid value in the enum
			switch (StringUtils.trim(name.toLowerCase())) {
				case EDITABLE_NAME:
					result = EDITABLE;
					break;
				case ENABLED_NAME:
					result = ENABLED;
					break;
				case HIDE_NAME:
					result = HIDE;
					break;
				case VISIBLE_NAME:
					result = VISIBLE;
					break;
				default:
					result = ENABLED;
			}
			return result;
		}

		{
			_enumCreated = true;
		}

		/**
		 * Creates a new <code>AccessStrategy</code> object.
		 * This constructor is only used internally to set up the enum and all external
		 * calls will fail.
		 * @param name the name of the scope
		 */
		public function AccessStrategy(name:String) {
			Assert.state(!_enumCreated, "The AccessStrategy enum has already been created.");
			_name = name;
		}

		private var _name:String;

		/**
		 * Returns the name of the access strategy.
		 */
		public function get name():String {
			return _name;
		}

		/**
		 * Returns a string representation of the current <code>AccessStrategy</code>
		 * @return the string representation
		 */
		public function toString():String {
			return _name;
		}
	}
}
