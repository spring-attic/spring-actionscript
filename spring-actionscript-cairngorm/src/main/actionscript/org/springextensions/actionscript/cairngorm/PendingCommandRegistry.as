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
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	* Dispatched when an <code>ICommand</code> is unregistered in the current <code>PendingCommandRegistry</code>.
	* @eventType org.springextensions.actionscript.cairngorm.PendingCommandRegistryEvent.UNREGISTER
	*/
	[Event(name="unregister","org.springextensions.actionscript.cairngorm.PendingCommandRegistryEvent")]
	/**
	* Dispatched when an <code>ICommand</code> is registered in the current <code>PendingCommandRegistry</code>.
	* @eventType org.springextensions.actionscript.cairngorm.PendingCommandRegistryEvent.REGISTER
	*/
	[Event(name="register","org.springextensions.actionscript.cairngorm.PendingCommandRegistryEvent")]
	/**
	 * @author Christophe Herreman
	 * @docref extensions-documentation.html#event_sequences
	 */
	public class PendingCommandRegistry extends EventDispatcher {
		
		private static var _instance:PendingCommandRegistry;
		
		private var _pendingCommands:Dictionary;
		
		public function PendingCommandRegistry() {
			_pendingCommands = new Dictionary(true);
		}
		
		public static function getInstance():PendingCommandRegistry {
			if (!_instance)
				_instance = new PendingCommandRegistry();
			return _instance;
		}
		
		public function register(cmd:ICommand, event:CairngormEvent):void {
			_pendingCommands[event] = cmd;
			dispatchEvent(new PendingCommandRegistryEvent(PendingCommandRegistryEvent.REGISTER, cmd, event));
		}
		
		public function unregister(cmd:ICommand):void {
			for (var e:*in _pendingCommands) {
				if (_pendingCommands[e] === cmd) {
					dispatchEvent(new PendingCommandRegistryEvent(PendingCommandRegistryEvent.UNREGISTER, cmd, e));
					delete _pendingCommands[e];
				}
			}
		}
	}
}
