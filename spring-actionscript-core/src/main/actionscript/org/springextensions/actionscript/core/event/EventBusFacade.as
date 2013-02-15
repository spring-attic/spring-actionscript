/*
 * Copyright 2007-2011 the original author or authors.
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

	import org.as3commons.reflect.MethodInvoker;

	[Deprecated(message = "The EventBusFacade is deprecated in favour of a non-static injectable alterative ", replacement = "org.as3commons.eventbus.impl.EventBus", since = "v1.2")]
	/**
	 * Basic implementation of the <code>IEventBus</code> interface that acts as
	 * a facade for the static <code>EventBus</code> class. Every method is
	 * re-rerouted to the static equivalent in the <code>EventBus</code> class.
	 * <p>Implemented to make mocking the <code>EventBus</code> a little easier.</p>
	 * @see org.springextensions.actionscript.core.event.EventBus EventBus
	 * @author Roland Zwaga
	 * @docref the_eventbus.html#the_eventbus_introduction
	 */
	public class EventBusFacade implements IEventBus {

		/**
		 * Creates a new <code>EventBusFacade</code> instance.
		 */
		public function EventBusFacade() {
			super();
		}

		/**
		 * @see org.springextensions.actionscript.core.event.EventBus#addListener() EventBus.addListener()
		 * @inheritDoc
		 */
		public function addListener(listener:IEventBusListener, useWeakReference:Boolean = false):void {
			EventBus.addListener(listener, useWeakReference);
		}

		/**
		 * @see org.springextensions.actionscript.core.event.EventBus#removeListener() EventBus.removeListener()
		 * @inheritDoc
		 */
		public function removeListener(listener:IEventBusListener):void {
			EventBus.removeListener(listener);
		}

		/**
		 * @see org.springextensions.actionscript.core.event.EventBus#addEventListener() EventBus.addEventListener()
		 * @inheritDoc
		 */
		public function addEventListener(type:String, listener:Function, useWeakReference:Boolean = false):void {
			EventBus.addEventListener(type, listener, useWeakReference);
		}

		/**
		 * @see org.springextensions.actionscript.core.event.EventBus#removeEventListener() EventBus.removeEventListener()
		 * @inheritDoc
		 */
		public function removeEventListener(type:String, listener:Function):void {
			EventBus.removeEventListener(type, listener);
		}

		/**
		 * @see org.springextensions.actionscript.core.event.EventBus#addEventListenerProxy() EventBus.addEventListenerProxy()
		 * @inheritDoc
		 */
		public function addEventListenerProxy(type:String, proxy:MethodInvoker, useWeakReference:Boolean = false):void {
			EventBus.addEventListenerProxy(type, proxy, useWeakReference);
		}

		/**
		 * @see org.springextensions.actionscript.core.event.EventBus#removeEventListenerProxy() EventBus.removeEventListenerProxy()
		 * @inheritDoc
		 */
		public function removeEventListenerProxy(type:String, proxy:MethodInvoker):void {
			EventBus.removeEventListenerProxy(type, proxy);
		}

		/**
		 * @see org.springextensions.actionscript.core.event.EventBus#addEventClassListener() EventBus.addEventClassListener()
		 * @inheritDoc
		 */
		public function addEventClassListener(eventClass:Class, listener:Function, useWeakReference:Boolean = false):void {
			EventBus.addEventClassListener(eventClass, listener, useWeakReference);
		}

		/**
		 * @see org.springextensions.actionscript.core.event.EventBus#removeEventClassListener() EventBus.removeEventClassListener()
		 * @inheritDoc
		 */
		public function removeEventClassListener(eventClass:Class, listener:Function):void {
			EventBus.removeEventClassListener(eventClass, listener);
		}

		/**
		 * @see org.springextensions.actionscript.core.event.EventBus#addEventClassListenerProxy() EventBus.addEventClassListenerProxy()
		 * @inheritDoc
		 */
		public function addEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker, useWeakReference:Boolean = false):void {
			EventBus.addEventClassListenerProxy(eventClass, proxy, useWeakReference);
		}

		/**
		 * @see org.springextensions.actionscript.core.event.EventBus#removeEventClassListenerProxy() EventBus.removeEventClassListenerProxy()
		 * @inheritDoc
		 */
		public function removeEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker):void {
			EventBus.removeEventClassListenerProxy(eventClass, proxy);
		}

		/**
		 * @see org.springextensions.actionscript.core.event.EventBus#removeAll() EventBus.removeAll()
		 * @inheritDoc
		 */
		public function removeAll():void {
			EventBus.removeAll();
		}

		/**
		 * @see org.springextensions.actionscript.core.event.EventBus#dispatchEvent() EventBus.dispatchEvent()
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event):void {
			EventBus.dispatchEvent(event);
		}

		/**
		 * @see org.springextensions.actionscript.core.event.EventBus#dispatch() EventBus.dispatch()
		 * @inheritDoc
		 */
		public function dispatch(type:String):void {
			EventBus.dispatch(type);
		}
	}
}
