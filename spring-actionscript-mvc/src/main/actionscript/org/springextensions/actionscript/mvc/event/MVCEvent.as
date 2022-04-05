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

	import org.as3commons.lang.StringUtils;

	/**
	 * Event class used by the Controller instance to recognize MVC related events and
	 * associate it with either an <code>Application</code> or <code>Module</code>.
	 * @author Roland Zwaga
	 */
	public class MVCEvent extends Event {

		/**
		 *
		 */
		public static const MVC_EVENT:String = "MVCEvent";

		private var _document:Object;

		/**
		 * The document that is associated with the wrapped event, typically this will be either an <code>Application</code> or <code>Module</code> instance.
		 */
		public function get document():Object {
			return _document;
		}

		private var _event:Event;

		/**
		 * The original <code>Event</code> wrapped by the current <code>MVCEvent</code>.
		 */
		public function get event():Event {
			return _event;
		}

		/**
		 * Creates a new <code>MVCEvent</code> instance.
		 * @param document The document that the specified <code>Event</code> originated from.
		 * @param event The specified <code>Event</code>.
		 */
		public function MVCEvent(document:Object, event:Event, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(MVC_EVENT, bubbles, cancelable);
			_event = event;
			_document = document;
		}

		/**
		 * An exact copy of the current <code>MVCEvent</code>.
		 */
		override public function clone():Event {
			return new MVCEvent(_document, _event, bubbles, cancelable);
		}

		/**
		 * A <code>String</code> representing the current <code>MVCEvent</code>.
		 */
		override public function toString():String {
			return StringUtils.substitute("[MVCEvent(document={0}, event={1}, bubbles={2}, cancelable={3})]", _document, _event, this.bubbles, this.cancelable);
		}
	}
}
