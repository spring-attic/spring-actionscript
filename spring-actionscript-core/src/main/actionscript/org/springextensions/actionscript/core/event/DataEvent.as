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
package org.springextensions.actionscript.core.event {

	import flash.events.Event;

	/**
	 * The DataEvent class is an <code>Event</code> that carries a <code>data</code> property that can be used as a generic data container
	 * for the payload of the event. It is recommended to create event classes with strongly typed data properties however, so use this class
	 * only if the type of data is not known.
	 * @author Christophe Herreman
	 * @docref the_eventbus.html#the_eventbus_introduction
	 */
	public class DataEvent extends Event {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>DataEvent</code> instance.
		 * @param type The type of the current <code>DataEvent</code>.
		 * @param data The data payload of the current <code>DataEvent</code>.
		 * @inheritDoc
		 */
		public function DataEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.data = data;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// data
		// ----------------------------

		private var _data:*;

		public function get data():* {
			return _data;
		}

		public function set data(value:*):void {
			if (value !== _data) {
				_data = value;
			}
		}
		
		/**
		 * @return An exact copy of the current <code>DataEvent</code>.
		 */
		override public function clone():Event {
			return new DataEvent(this.type,this.data,this.bubbles,this.cancelable);
		}
	}
}