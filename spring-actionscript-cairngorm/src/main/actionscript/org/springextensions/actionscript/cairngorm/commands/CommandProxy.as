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
package org.springextensions.actionscript.cairngorm.commands {
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.*;
	
	import mx.rpc.IResponder;
	
	import org.springextensions.actionscript.cairngorm.PendingCommandRegistry;
	
	use namespace flash_proxy;
	
	/**
	 * @author Christophe Herreman
	 * @docref extensions-documentation.html#the_command_factory
	 */
	public class CommandProxy extends Proxy implements IEventDispatcher, ICommand {
		
		private var _command:ICommand;
		
		private var _eventDispatcher:IEventDispatcher;
		
		public function CommandProxy(command:ICommand) {
			_command = command;
			_eventDispatcher = new EventDispatcher(this);
		}
		
		public function execute(event:CairngormEvent):void {
			var isResponder:Boolean = _command is IResponder;
			
			// execute the command
			_command.execute(event);
			
			// if this command does not implement the IResponder interface, we
			// unregister it as pending so the user does not have to
			// in the other case, the user is responsible for unregistering
			// manually (this will happen in the result() or fault())
			if (!isResponder) {
				PendingCommandRegistry.getInstance().unregister(_command);
					// wrap result() and fault()
					// TODO find solution for this if we want to automate the sequencing
			}
		
			//dispatchEvent(new Event("executeComplete"));
		}
		
		/*flash_proxy override function callProperty(name:*, ...args):* {
		   if (name is QName) {
		   switch (name.localName) {
		   case "execute":
		   execute.apply(this, args);
		   break;
		   }
		   }
		 }*/
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(event:Event):Boolean {
			return _eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean {
			return _eventDispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean {
			return _eventDispatcher.willTrigger(type);
		}
	}
}
