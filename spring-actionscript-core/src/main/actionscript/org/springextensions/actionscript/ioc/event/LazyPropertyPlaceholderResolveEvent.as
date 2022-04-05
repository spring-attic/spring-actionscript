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
package org.springextensions.actionscript.ioc.event {

	import flash.events.Event;
	
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ArgumentDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.MethodInvocation;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class LazyPropertyPlaceholderResolveEvent extends Event {
		
		public static const RESOLVE_PROPERTY_DEFINITION_PLACEHOLDERS:String = "resolvePropertyDefinitionPlaceholders";
		public static const RESOLVE_ARGUMENT_DEFINITION_PLACEHOLDERS:String = "resolveArgumentDefinitionPlaceholders";
		public static const RESOLVE_METHOD_INVOCATION_PLACEHOLDERS:String = "resolveMethodInvocationPlaceholders";
		
		private var _propertyDefinition:PropertyDefinition;
		private var _resolved:Boolean;
		private var _argumentDefinition:ArgumentDefinition;
		private var _methodInvocation:MethodInvocation;

		/**
		 * Creates a new <code>LazyPropertyPlaceholderResolveEvent</code> instance.
		 */
		public function LazyPropertyPlaceholderResolveEvent(type:String, propDef:PropertyDefinition, argDefinition:ArgumentDefinition=null, methodInvoc:MethodInvocation=null, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_propertyDefinition = propDef;
			_argumentDefinition = argDefinition;
			_methodInvocation = methodInvoc;
		}

		public function get methodInvocation():MethodInvocation {
			return _methodInvocation;
		}

		public function set methodInvocation(value:MethodInvocation):void {
			_methodInvocation = value;
		}

		public function get argumentDefinition():ArgumentDefinition {
			return _argumentDefinition;
		}

		public function set argumentDefinition(value:ArgumentDefinition):void {
			_argumentDefinition = value;
		}

		public function get resolved():Boolean {
			return _resolved;
		}

		public function set resolved(value:Boolean):void {
			_resolved = value;
		}

		public function get propertyDefinition():PropertyDefinition {
			return _propertyDefinition;
		}

		public function set propertyDefinition(value:PropertyDefinition):void {
			_propertyDefinition = value;
		}
		
		override public function clone():Event {
			var event:LazyPropertyPlaceholderResolveEvent = new LazyPropertyPlaceholderResolveEvent(type, _propertyDefinition, _argumentDefinition, _methodInvocation, bubbles, cancelable);
			event.resolved = _resolved;
			return event;
		}

	}
}
