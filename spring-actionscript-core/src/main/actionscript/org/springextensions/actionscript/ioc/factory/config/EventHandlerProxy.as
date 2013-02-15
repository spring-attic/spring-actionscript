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
package org.springextensions.actionscript.ioc.factory.config {

	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.IllegalArgumentError;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.MethodInvoker;
	import org.as3commons.reflect.Parameter;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.Variable;
	import org.springextensions.actionscript.ioc.factory.IApplicationDomainAware;

	/**
	 * Proxied method invoker for event handlers.
	 * @author Christophe Herreman
	 * @docref the_eventbus.html#eventbus_event_handling_using_metadata_annotations
	 */
	public class EventHandlerProxy extends MethodInvoker implements IApplicationDomainAware {

		protected var event:Event;
		protected var methodInstance:Method;
		protected var properties:Array;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>EventHandlerProxy</code> instance.
		 * @param target
		 * @param method
		 * @param properties
		 */
		public function EventHandlerProxy(target:Object, method:Method, properties:Array = null) {
			super();
			init(target, method, properties);
		}
		
		/**
		 * Initializes the current <code>EventHandlerProxy</code>.
		 * @param target
		 * @param method
		 * @param properties
		 */
		protected function init(target:Object, method:Method, properties:Array):void {
			this.target = target;
			this.method = method.name;
			methodInstance = method;
			this.properties = properties;
		}
		
		private var _applicationDomain:ApplicationDomain;
		/**
		 * @private
		 */
		public function get applicationDomain():ApplicationDomain {
			return _applicationDomain;
		}
		/**
		 * @inheritDoc
		 */
		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
		}


		// --------------------------------------------------------------------
		//
		// Overrides
		//
		// --------------------------------------------------------------------

		/**
		 * When setting the argument(s) for this proxy (which should be an Event), we save the Event in the protected
		 * event variable.
		 * @param value
		 */
		override public function set arguments(value:Array):void {
			super.arguments = value;

			if (value && value.length > 0 && (value[0] is Event)) {
				event = Event(value[0]);
			}
		}

		/**
		 * Invokes the event handler for the proxied method and decides what arguments to use, based on the
		 * metadata of event handler function.
		 *
		 * @return
		 */
		override public function invoke():* {
			Assert.state(event != null, "No Event was set.");
			super.arguments = getArguments();
			return super.invoke();
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Returns the arguments that need to be used for invoking the proxied result handler.
		 *
		 * @return
		 */
		protected function getArguments():Array {
			if (properties) {
				// return the arguments based on the mapping of the event properties
				return getArgumentsFromProperties(properties);
			}
			return getArgumentsFromMethod();
		}

		/**
		 * Returns the arguments based on the 'properties' value of the EventHandler annotation.
		 *
		 * @param properties
		 * @return
		 */
		protected function getArgumentsFromProperties(properties:Array):Array {
			var result:Array = [];
			var numProperties:int = properties.length;

			for (var i:int = 0; i<numProperties; i++) {
				result[result.length]= event[properties[i]];
			}

			return result;
		}

		/**
		 * Returns the arguments based on the method signature of the proxied event handler.
		 *
		 * @return
		 */
		protected function getArgumentsFromMethod():Array {
			var numParameters:uint = methodInstance.parameters.length;

			switch (numParameters) {
				case 0:
					return [];
				case 1:
					var paramClass:Class = Parameter(methodInstance.parameters[0]).type.clazz;
					if (ClassUtils.isAssignableFrom(Event, paramClass)) {
						return [event];
					}
				default:
					return getArgumentsFromMethodParameters(methodInstance);
			}
		}

		/**
		 * Returns the arguments based on the proxied method parameters.
		 * @param method The specified <code>Method</code> instance.
		 * @return An <code>Array</code> of argument objects.
		 */
		protected function getArgumentsFromMethodParameters(method:Method):Array {
			if (hasMultipleParametersOfSameType(method)) {
				throw new IllegalArgumentError("The method '" + method.name + "' has multiple parameters of the same type. " +
				                               "Please specify the properties to use via the 'properties' argument on the " +
				                               "[EventHandler] metadata.");
			}

			var result:Array = [];
			var numParameters:uint = method.parameters.length;

			for (var i:int = 0; i < numParameters; i++) {
				var param:Parameter = Parameter(method.parameters[i]);
				result[result.length] = getEventPropertyByType(event, param.type);
			}

			return result;
		}

		/**
		 * Returns <code>true</code> if the specified <code>Method</code> has multiple parameters of the same type.
		 * @param method The specified <code>Method</code>.
		 * @return <code>true</code> if the given method has multiple parameters of the same type.
		 */
		protected function hasMultipleParametersOfSameType(method:Method):Boolean {
			var types:Array = [];

			for each (var param:Parameter in method.parameters) {
				if (types.indexOf(param.type) > -1) {
					return true;
				} else {
					types[types.length] = param.type;
				}
			}

			return false;
		}

		/**
		 * Returns a property of the given event that is of the given type.
		 * @param event
		 * @param type
		 * @return
		 */
		protected function getEventPropertyByType(event:Event, type:Type):Object {
			var eventType:Type = Type.forInstance(event, _applicationDomain);

			for each (var variable:Variable in eventType.variables) {
				if (variable.type == type) {
					return event[variable.name];
				}
			}

			for each (var accessor:Accessor in eventType.accessors) {
				if (accessor.readable && (accessor.type == type)) {
					return event[accessor.name];
				}
			}

			throw new IllegalArgumentError("The event class '" + eventType.clazz + "' does not have a property of " +
			                               "type '" + type.clazz + "'");
		}
	}
}