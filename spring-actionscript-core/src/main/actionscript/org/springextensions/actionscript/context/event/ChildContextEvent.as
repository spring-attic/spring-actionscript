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
package org.springextensions.actionscript.context.event {

	import flash.events.Event;
	import org.springextensions.actionscript.context.ContextShareSettings;
	import org.springextensions.actionscript.context.IApplicationContext;

	/**
	 * Dispatched by an <code>IApplicationContext</code> that acts like a parent context before and after it adds child contexts.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ChildContextEvent extends Event {

		/**
		 *
		 */
		public static const AFTER_CHILD_CONTEXT_REMOVE:String = "afterChildContextRemove";
		/**
		 *
		 */
		public static const BEFORE_CHILD_CONTEXT_REMOVE:String = "beforeChildContextRemove";
		/**
		 *
		 */
		public static const BEFORE_CHILD_CONTEXT_ADD:String = "beforeChildContextAdd";
		/**
		 *
		 */
		public static const AFTER_CHILD_CONTEXT_ADD:String = "afterChildContextAdd";

		/**
		 * Creates a new <code>ChildContextEvent</code> instance.
		 */
		public function ChildContextEvent(type:String, child:IApplicationContext, settings:ContextShareSettings=null, customFunction:Function=null, bubbles:Boolean=false, cancelable:Boolean=true) {
			super(type, bubbles, cancelable);
			_childContext = child;
			_shareSettings = settings;
			_customAddChildFunction = customFunction;
		}

		private var _childContext:IApplicationContext;
		private var _customAddChildFunction:Function;
		private var _shareSettings:ContextShareSettings;

		/**
		 * The <code>IApplicationContext</code> instance that will be added to the parent context.
		 */
		public function get childContext():IApplicationContext {
			return _childContext;
		}

		/**
		 * @private
		 */
		public function set childContext(value:IApplicationContext):void {
			_childContext = value;
		}

		/**
		 * Custom <code>Function</code> to override the child context addage logic completely, the signature of this <code>Function</code> must be as follows:<br/>
		 * <code>function(parentContext:IApplicationContext, childContext:IApplicationContext, settings:ContextShareSettings):void;</code>
		 */
		public function get customAddChildFunction():Function {
			return _customAddChildFunction;
		}

		/**
		 * @private
		 */
		public function set customAddChildFunction(value:Function):void {
			_customAddChildFunction = value;
		}

		/**
		 * Describes which aspects of the parent context will be shared with the child context.
		 */
		public function get shareSettings():ContextShareSettings {
			return _shareSettings;
		}

		/**
		 * @private
		 */
		public function set shareSettings(value:ContextShareSettings):void {
			_shareSettings = value;
		}

		/**
		 * Returns an exact copy of the current <code>ChildContextEvent</code>.
		 * @return An exact copy of the current <code>ChildContextEvent</code>.
		 */
		override public function clone():Event {
			return new ChildContextEvent(type, childContext, shareSettings, customAddChildFunction, bubbles, cancelable);
		}
	}
}
