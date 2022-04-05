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
package org.springextensions.actionscript.mvc.event {

	import flash.events.Event;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class ControllerEvent extends Event {

		/**
		 *
		 */
		public static const BEFORE_COMMAND_EXECUTED:String = "controllerBeforeCommandExecuted";

		/**
		 *
		 */
		public static const AFTER_COMMAND_EXECUTED:String = "controllerAfterCommandExecuted";

		private var _command:Object;

		/**
		 *
		 */
		public function get command():Object {
			return _command;
		}

		/**
		 *
		 * @param type
		 * @param command
		 * @param bubbles
		 * @param cancelable
		 */
		public function ControllerEvent(type:String, command:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_command = command;
		}

		/**
		 *
		 */
		override public function clone():Event {
			return new ControllerEvent(this.type, _command, this.bubbles, this.cancelable);
		}
	}
}
