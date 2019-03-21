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
package org.springextensions.actionscript.eventbus {
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import org.as3commons.eventbus.IEventInterceptor;
	import org.as3commons.eventbus.IEventListenerInterceptor;
	import org.as3commons.reflect.MethodInvoker;
	import org.springextensions.actionscript.eventbus.process.EventHandlerProxy;

	/**
	 * Describes an object that keeps track of all the types of listeners and interceptors added to an <code>IEventBus</code>.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public interface IEventBusUserRegistry {

		/**
		 *
		 * @param eventClass
		 * @param interceptor
		 * @param topic
		 */
		function addEventClassInterceptor(eventClass:Class, interceptor:IEventInterceptor, topic:Object=null):void;

		/**
		 *
		 * @param eventClass
		 * @param interceptor
		 * @param topic
		 */
		function addEventClassListenerInterceptor(eventClass:Class, interceptor:IEventListenerInterceptor, topic:Object=null):void;

		/**
		 *
		 * @param eventClass
		 * @param proxy
		 * @param useWeakReference
		 * @param topic
		 * @return
		 */
		function addEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker, useWeakReference:Boolean=false, topic:Object=null):Boolean;

		/**
		 *
		 * @param type
		 * @param interceptor
		 * @param topic
		 */
		function addEventInterceptor(type:String, interceptor:IEventInterceptor, topic:Object=null):void;

		/**
		 *
		 * @param type
		 * @param interceptor
		 * @param topic
		 */
		function addEventListenerInterceptor(type:String, interceptor:IEventListenerInterceptor, topic:Object=null):void;

		/**
		 *
		 * @param type
		 * @param proxy
		 * @param useWeakReference
		 * @param topic
		 * @return
		 */
		function addEventListenerProxy(type:String, proxy:MethodInvoker, useWeakReference:Boolean=false, topic:Object=null):Boolean;

		/**
		 *
		 * @param eventDispatcher
		 * @param eventTypes
		 * @param topics
		 */
		function addEventListeners(eventDispatcher:IEventDispatcher, eventTypes:Vector.<String>, topics:Array):void;

		/**
		 *
		 * @param interceptor
		 * @param topic
		 */
		function addInterceptor(interceptor:IEventInterceptor, topic:Object=null):void;

		/**
		 *
		 * @param interceptor
		 * @param topic
		 */
		function addListenerInterceptor(interceptor:IEventListenerInterceptor, topic:Object=null):void;

		/**
		 *
		 * @param eventClass
		 * @param interceptor
		 * @param topic
		 */
		function removeEventClassInterceptor(eventClass:Class, interceptor:IEventInterceptor, topic:Object=null):void;

		/**
		 *
		 * @param eventClass
		 * @param interceptor
		 * @param topic
		 */
		function removeEventClassListenerInterceptor(eventClass:Class, interceptor:IEventListenerInterceptor, topic:Object=null):void;

		/**
		 *
		 * @param eventClass
		 * @param proxy
		 * @param topic
		 */
		function removeEventClassListenerProxy(eventClass:Class, proxy:MethodInvoker, topic:Object=null):void;

		/**
		 *
		 * @param type
		 * @param interceptor
		 * @param topic
		 */
		function removeEventInterceptor(type:String, interceptor:IEventInterceptor, topic:Object=null):void;

		/**
		 *
		 * @param type
		 * @param interceptor
		 * @param topic
		 */
		function removeEventListenerInterceptor(type:String, interceptor:IEventListenerInterceptor, topic:Object=null):void;

		/**
		 *
		 * @param type
		 * @param proxy
		 * @param topic
		 */
		function removeEventListenerProxy(type:String, proxy:MethodInvoker, topic:Object=null):void;

		/**
		 *
		 * @param interceptor
		 * @param topic
		 */
		function removeInterceptor(interceptor:IEventInterceptor, topic:Object=null):void;

		/**
		 *
		 * @param interceptor
		 * @param topic
		 */
		function removeListenerInterceptor(interceptor:IEventListenerInterceptor, topic:Object=null):void;

		/**
		 *
		 * @param eventDispatcher
		 */
		function removeEventListeners(eventDispatcher:IEventDispatcher):void;

		/**
		 *
		 * @param target
		 */
		function clearAllProxyRegistrations(target:Object):void;
	}
}
