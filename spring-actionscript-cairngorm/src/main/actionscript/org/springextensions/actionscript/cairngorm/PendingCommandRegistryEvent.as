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
package org.springextensions.actionscript.cairngorm {
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	/**
	 * Event that is dispatched by the <code>PendingCommandRegistry</code> when registering and unregistering <code>ICommand</code> instances.
	 * @author Christophe Herreman
	 * @docref extensions-documentation.html#event_sequences
	 */
	public class PendingCommandRegistryEvent extends Event {
		
		/**
		 * Defines the value of the type property of a <code>PendingCommandRegistryEvent.REGISTER</code> event object.
		 * @eventType String
		 */
		public static const REGISTER:String = "register";
		
		/**
		 * Defines the value of the type property of a <code>PendingCommandRegistryEvent.UNREGISTER</code> event object.
		 * @eventType String
		 */
		public static const UNREGISTER:String = "unregister";
		
		/**
		 * The <code>ICommand</code> instance that this event refers to.
		 */
		public var command:ICommand;
		
		/**
		 * The <code>CairngormEvent</code> instance associated to the <code>ICommand</code> instance that this event refers to.
		 */
		public var event:CairngormEvent;
		
		public function PendingCommandRegistryEvent(type:String, command:ICommand, event:CairngormEvent) {
			super(type);
			this.command = command;
			this.event = event;
		}
		
		/**
		 * Returns an exact copy of the current <code>PendingCommandRegistryEvent</code> instance.
		 */
		override public function clone():Event {
			return new PendingCommandRegistryEvent(this.type, this.command, this.event);
		}
	
	}
}
