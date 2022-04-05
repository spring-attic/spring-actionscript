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
package org.springextensions.actionscript.ioc.config.impl.mxml.component {
	import flash.events.Event;

	import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinition;

	[DefaultProperty("value")]
	/**
	 * MXML representation of a <code>Property</code> object. This non-visual component must be declared as
	 * a child component of a <code>ObjectDefinition</code> component.
	 * @see org.springextensions.actionscript.context.support.mxml.MXMLObjectDefinition ObjectDefinition
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class Property extends Arg {
		public static const ISSTATIC_CHANGED_EVENT:String = "isStaticChanged";
		public static const ISLAZY_CHANGED_EVENT:String = "isLazyChanged";
		public static const NAME_CHANGED_EVENT:String = "nameChanged";
		public static const NAMESPACEURI_CHANGED_EVENT:String = "namespaceURIChanged";
		public static const LAZYPROPERTYRESOLVING_CHANGED_EVENT:String = "lazyPropertyResolvingChanged";

		/**
		 * Creates a new <code>Property</code> instance
		 */
		public function Property() {
			super();
		}

		private var _isStatic:Boolean = false;
		private var _isLazy:Boolean = false;
		private var _name:String;
		private var _namespaceURI:String;

		[Bindable(event="isStaticChanged")]
		public function get isStatic():Boolean {
			return _isStatic;
		}

		public function set isStatic(value:Boolean):void {
			if (_isStatic != value) {
				_isStatic = value;
				dispatchEvent(new Event(ISSTATIC_CHANGED_EVENT));
			}
		}

		[Bindable(event="isLazyChanged")]
		public function get isLazy():Boolean {
			return _isLazy;
		}

		public function set isLazy(value:Boolean):void {
			if (_isLazy != value) {
				_isLazy = value;
				dispatchEvent(new Event(ISLAZY_CHANGED_EVENT));
			}
		}

		[Bindable(event="nameChanged")]
		public function get name():String {
			return _name;
		}

		public function set name(value:String):void {
			if (_name != value) {
				_name = value;
				dispatchEvent(new Event(NAME_CHANGED_EVENT));
			}
		}

		[Bindable(event="namespaceURIChanged")]
		public function get namespaceURI():String {
			return _namespaceURI;
		}

		public function set namespaceURI(value:String):void {
			if (_namespaceURI != value) {
				_namespaceURI = value;
				dispatchEvent(new Event(NAMESPACEURI_CHANGED_EVENT));
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function clone():* {
			var clone:Property = new Property();
			clone.name = this.name;
			clone.ref = this.ref;
			clone.type = this.type;
			clone.value = this.value;
			clone.namespaceURI = this.namespaceURI;
			clone.isLazy = this.isLazy;
			clone.lazyPropertyResolving = this.lazyPropertyResolving;
			return clone;
		}

		public function toPropertyDefinition():PropertyDefinition {
			var propertyDefinition:PropertyDefinition = new PropertyDefinition(_name, value, _namespaceURI, _isStatic, _isLazy, lazyPropertyResolving);
			propertyDefinition.isLazy = _isLazy;
			return propertyDefinition;
		}
	}
}
