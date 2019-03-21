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
package org.springextensions.actionscript.ioc.factory.event {

	import flash.events.Event;
	
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ArgumentDefinition;

	/**
	 * Event that is dispatched at various stages of object creation by an object factory.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ObjectFactoryEvent extends Event {

		/**
		 *
		 */
		public static const OBJECT_CREATED:String = "objectCreated";
		/**
		 *
		 */
		public static const OBJECT_RETRIEVED:String = "objectRetrieved";
		/**
		 *
		 */
		public static const OBJECT_WIRED:String = "objectWired";

		private var _objectInstance:*;
		private var _objectName:String;
		private var _constructorArguments:Vector.<ArgumentDefinition>;

		/**
		 * Creates a new <code>ObjectFactoryEvent</code> instance.
		 * @param instance The managed instance that this event refers to.
		 * @param name The name of the object as its known by the object factory.
		 * @param constructorArgs The constructor arguments passed to the object factory for the specified instance.
		 */
		public function ObjectFactoryEvent(type:String, instance:*, name:String, constructorArgs:Vector.<ArgumentDefinition> = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			_objectInstance = instance;
			_objectName = name;
			_constructorArguments = constructorArgs;
		}


		/**
		 * The constructor arguments passed to the object factory for the specified instance.
		 */
		public function get constructorArguments():Vector.<ArgumentDefinition> {
			return _constructorArguments;
		}

		/**
		 * The managed instance that this event refers to.
		 */
		public function get objectInstance():* {
			return _objectInstance;
		}

		/**
		 * The name of the object as its known by the object factory.
		 */
		public function get objectName():String {
			return _objectName;
		}

		/**
		 * Returns an exact copy of the current <code>ObjectFactoryEvent</code>.
		 * @return An exact copy of the current <code>ObjectFactoryEvent</code>.
		 */
		override public function clone():Event {
			return new ObjectFactoryEvent(type, _objectInstance, _objectName, _constructorArguments, bubbles, cancelable);
		}

	}
}
