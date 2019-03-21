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
package org.springextensions.actionscript.mvc.impl {
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	/**
	 * Describes the execution of an abritrary command class after an event was dispatched.
	 * @author Roland Zwaga
	 */
	public class CommandRegistration {

		private var _executeMethodName:String;

		/**
		 * @return The name of the method that will be invoked on the command instance.
		 */
		public function get executeMethodName():String {
			return _executeMethodName;
		}

		private var _commandName:String;

		/**
		 * @return The name of the command instance as it is known in the application context/
		 */
		public function get commandName():String {
			return _commandName;
		}

		private var _priority:uint;

		/**
		 * @return When more than one command is registered for an <code>Event</code> this indicates which command is executed first, the higher the value the higher up in the list.
		 */
		public function get priority():uint {
			return _priority;
		}

		private var _properties:Vector.<String>;

		/**
		 * A list of property names on the <code>Event</code> instance that will be mapped either to the arguments of the execution method or to properties on the command instance.
		 * @return
		 *
		 */
		public function get properties():Vector.<String> {
			return _properties;
		}

		/**
		 * Creates a new <code>CommandRegistration</code> instance.
		 * @param commandName
		 * @param executeMethodName
		 * @param properties
		 * @param priority
		 */
		public function CommandRegistration(commandName:String, executeMethodName:String, properties:Vector.<String>=null, priority:uint=0) {
			Assert.hasText(commandName, "commandName argument must not be null or empty");
			Assert.hasText(executeMethodName, "executeMethodName argument must not be null or empty");
			_commandName = commandName;
			_executeMethodName = executeMethodName;
			_properties = properties;
			_priority = priority;
		}

		/**
		 * @return A <code>String</code> representation of the current <code>CommandRegistration</code>.
		 */
		public function toString():String {
			return StringUtils.substitute("[CommandRegistration(commandName={0},executeMethodName={1},priority={2),properties={3})]", _commandName, _executeMethodName, _priority, _properties.join(','));
		}
	}
}
