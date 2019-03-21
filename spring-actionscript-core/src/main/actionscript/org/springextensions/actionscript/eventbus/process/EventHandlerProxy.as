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
package org.springextensions.actionscript.eventbus.process {
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.IApplicationDomainAware;
	import org.as3commons.lang.IEquals;
	import org.as3commons.lang.IllegalArgumentError;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.MethodInvoker;
	import org.as3commons.reflect.Parameter;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.Variable;

	/**
	 * Proxied method invoker for event handlers.
	 * @author Christophe Herreman
	 */
	public class EventHandlerProxy extends MethodInvoker implements IApplicationDomainAware, IEquals {

		/**
		 * Creates a new <code>EventHandlerProxy</code> instance.
		 * @param target
		 * @param method
		 * @param properties
		 */
		public function EventHandlerProxy(target:Object, method:Method, properties:Vector.<String>=null) {
			super();
			this.target = target;
			this.method = method.name;
			methodInstance = method;
			this.properties = properties;
		}

		public var event:Event;
		public var methodInstance:Method;
		public var properties:Vector.<String>;

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
		 *
		 * @param other
		 * @return
		 *
		 */
		override public function equals(other:Object):Boolean {
			var otherProxy:EventHandlerProxy = other as EventHandlerProxy;
			if (otherProxy != null) {
				return ((otherProxy.target === this.target) && //
					(otherProxy.method == this.method) && //
					(otherProxy.namespaceURI == this.namespaceURI) && //
					propertiesAreEqual(otherProxy.properties, this.properties));
			}
			return false;
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

		/**
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
		 *
		 * @param properties
		 * @return
		 */
		protected function getArgumentsFromProperties(properties:Vector.<String>):Array {
			var result:Array = [];

			for each (var propertyName:String in properties) {
				result[result.length] = event[propertyName];
			}

			return result;
		}

		private function getArgumentsFromMethodParameters(method:Method):Array {
			if (hasMultipleParametersOfSameType(method)) {
				throw new IllegalArgumentError("The method '" + method.name + "' has multiple parameters of the same type. " + "Please specify the properties to use via the 'properties' argument on the " + "[EventHandler] metadata.");
			}

			var result:Array = [];
			var numParameters:uint = method.parameters.length;

			for (var i:int = 0; i < numParameters; i++) {
				var param:Parameter = Parameter(method.parameters[i]);
				result[result.length] = getEventPropertyByType(event, param.type);
			}

			return result;
		}

		private function getEventPropertyByType(event:Event, type:Type):Object {
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

			throw new IllegalArgumentError("The event class '" + eventType.clazz + "' does not have a property of " + "type '" + type.clazz + "'");
		}

		private function hasMultipleParametersOfSameType(method:Method):Boolean {
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

		private function propertiesAreEqual(properties:Vector.<String>, otherProperties:Vector.<String>):Boolean {
			if ((properties == null) && (otherProperties == null)) {
				return true;
			} else if ((properties == null) || (otherProperties == null)) {
				return false;
			} else if ((properties.length != otherProperties.length)) {
				return false;
			}
			for each (var item:String in properties) {
				if (otherProperties.indexOf(item) < 0) {
					return false;
				}
			}
			return true;
		}
	}
}
