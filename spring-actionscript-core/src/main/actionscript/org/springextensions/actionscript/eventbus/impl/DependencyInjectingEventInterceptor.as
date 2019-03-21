/*
* Copyright 2007-2012 the original author or authors.
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
package org.springextensions.actionscript.eventbus.impl {

	import flash.events.Event;
	
	import org.as3commons.eventbus.IEventBus;
	import org.as3commons.eventbus.IEventInterceptor;
	import org.as3commons.eventbus.impl.AbstractEventInterceptor;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContextAware;

	/**
	 * Intercept events and lets them be wired by the specified <code>IApplicationContext</code>.<br/>
	 * An object definition may be present in the context, in which case it is assumed that this definition
	 * will have an id equal to the <code>Event.type</code> value.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class DependencyInjectingEventInterceptor extends AbstractEventInterceptor implements IApplicationContextAware {

		private var _applicationContext:IApplicationContext;

		/**
		 * Creates a new <code>InjectEventInterceptor</code> instance.
		 */
		public function DependencyInjectingEventInterceptor() {
			super();
		}

		/**
		 * Invokes the <code>IApplicationContext.manage()</code> method using the specified <code>Event</code> and its <code>type</code> property as arguments.
		 * @param event The specified <code>Event</code>
		 */
		override public function intercept(event:Event, topic:Object=null):Event {
			_applicationContext.manage(event, event.type);
			return event;
		}

		/**
		 * @inheritDoc
		 */
		public function get applicationContext():IApplicationContext {
			return _applicationContext;
		}

		/**
		 * @inheritDoc
		 */
		public function set applicationContext(value:IApplicationContext):void {
			_applicationContext = value;
		}
	}
}
