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
package org.springextensions.actionscript.mvc.impl {

	import flash.events.Event;
	import flash.system.ApplicationDomain;

	import org.as3commons.lang.Assert;
	import org.as3commons.reflect.Field;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.eventbus.process.EventHandlerProxy;

	/**
	 * Proxied method invoker for command objects.
	 * @author Roland Zwaga
	 */
	public class CommandProxy extends EventHandlerProxy {

		/**
		 * Creates a new <code>CommandProxy</code> instance.
		 */
		public function CommandProxy(target:Object, method:Method, properties:Vector.<String>, event:Event, applicationDomain:ApplicationDomain) {
			Assert.notNull(target, "target argument must not be null");
			Assert.notNull(method, "method argument must not be null");
			Assert.notNull(event, "event argument must not be null");
			Assert.notNull(applicationDomain, "applicationDomain argument must not be null");
			super(target, method, properties);
			this.event = event;
			applicationDomain = applicationDomain;
		}

		override protected function getArguments():Array {
			var args:Array = getArgumentsFromMethod();
			if (args.length > 0) {
				return args;
			} else {
				if (properties) {
					// return the arguments based on the mapping of the event properties
					args = getArgumentsFromProperties(properties);
					if (args.length == methodInstance.parameters.length) {
						return args;
					} else {
						setProperties(target, properties, args)
					}
				} else {
					mapPropertiesByType(target, event);
				}

			}
			return [];
		}

		public function setProperties(target:Object, properties:Vector.<String>, values:Array):void {
			Assert.notNull(target, "target argument must not be null");
			Assert.notNull(properties, "properties argument must not be null");
			Assert.notNull(values, "values argument must not be null");
			var i:uint = 0;
			for each (var prop:String in properties) {
				target[prop] = values[i++];
			}
		}

		public function mapPropertiesByType(target:Object, event:Event):void {
			Assert.notNull(target, "target argument must not be null");
			Assert.notNull(event, "event argument must not be null");
			var eventType:Type = Type.forInstance(event, applicationDomain);
			var targetType:Type = Type.forInstance(target, applicationDomain);
			var properties:Array = eventType.properties;
			var targetProperties:Array = targetType.properties;
			for each (var field:Field in properties) {
				targetProperties = mapField(target, event, field, targetProperties);
			}
		}

		public function mapField(target:Object, event:Event, eventField:Field, properties:Array):Array {
			var i:uint = 0;
			for each (var field:Field in properties) {
				if (field.name != "prototype") {
					if (eventField.type.clazz === field.type.clazz) {
						target[field.name] = event[eventField.name];
						properties.splice(i, 1);
						break;
					}
				}
				i++;
			}
			return properties;
		}


	}
}
