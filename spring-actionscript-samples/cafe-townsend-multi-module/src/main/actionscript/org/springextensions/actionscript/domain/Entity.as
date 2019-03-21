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
package org.springextensions.actionscript.domain {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	/**
	 * Entity acts as a base domain object for objects that hold a unique identity throughout their lifetime. This
	 * identity is presented by the "id" property in each entity.
	 *
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public class Entity extends BaseObject implements IEntity, IEventDispatcher {
	
		private static const PROPERTY_ID:String = "id";
	
		/**
		 * Creates a new Entity. If no id was passed to the constructor, -1 will be used.
		 * 
		 * @param id the id of this entity
		 */
		public function Entity(id:* = -1) {
			_eventDispatcher = new EventDispatcher(this);
			this.id = id;
		}
		private var _eventDispatcher:IEventDispatcher;
		private var _id:* = -1;
	
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
	
		public function dispatchEvent(event:Event):Boolean {
			return _eventDispatcher.dispatchEvent(event);
		}
		
		/**
		 * Checks for equality without looking at the id of the object.
		 */
		public function equalsWithoutIdentity(other:IEntity):Boolean {
			return doEquals(other, [PROPERTY_PROTOTOYPE, PROPERTY_ID]);
		}
	
		public function hasEventListener(type:String):Boolean {
			return _eventDispatcher.hasEventListener(type);
		}
	
		[Bindable]
		/**
		 * @inheritDoc
		 */
		public function get id():* {
			return _id;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set id(value:*):void {
			_id = value;
		}
	
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
	
		public function willTrigger(type:String):Boolean {
			return _eventDispatcher.willTrigger(type);
		}
		//---------------------------------------------------------------------
	}
}
