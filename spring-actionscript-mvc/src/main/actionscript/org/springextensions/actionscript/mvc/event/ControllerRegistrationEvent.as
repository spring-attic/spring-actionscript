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

	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.mvc.impl.CommandRegistration;

	/**
	 * Dispatched when a command is registered in a <code>Controller</code> instance.
	 * @author Roland Zwaga
	 */
	public class ControllerRegistrationEvent extends Event {

		public static const COMMAND_REGISTERED:String = "controllerCommandRegistered";

		private var _commandRegistration:CommandRegistration;

		public function get commandRegistration():CommandRegistration {
			return _commandRegistration;
		}

		private var _eventType:String;

		public function get eventType():String {
			return _eventType;
		}
		private var _eventClass:Class;

		public function get eventClass():Class {
			return _eventClass;
		}

		/**
		 * Creates a new <code>CommandRegistryEvent</code> instance.
		 * @param commandRegistration The specified <code>CommandRegistration</code> that describes how the command is associated with the event.
		 * @param eventType Not empty when the command registration is by type
		 * @param eventClass Not <code>null</code> when the command registration is by <code>Class</code>
		 */
		public function ControllerRegistrationEvent(commandRegistration:CommandRegistration, eventType:String="", eventClass:Class=null, bubbles:Boolean=false, cancelable:Boolean=false) {
			Assert.notNull(commandRegistration, "commandRegistration argument must not be null");
			super(COMMAND_REGISTERED, bubbles, cancelable);
			_commandRegistration = commandRegistration;
			_eventType = eventType;
			_eventClass = eventClass;
		}

		/**
		 * An exact copy of the current <code>ControllerRegistrationEvent</code>.
		 */
		override public function clone():Event {
			return new ControllerRegistrationEvent(_commandRegistration, _eventType, _eventClass, bubbles, cancelable);
		}
	}
}
