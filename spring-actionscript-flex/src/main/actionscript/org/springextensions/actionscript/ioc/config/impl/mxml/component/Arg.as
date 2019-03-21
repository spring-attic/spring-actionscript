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
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.objectdefinition.IBaseObjectDefinition;

	[DefaultProperty("value")]
	/**
	 * MXML representation of an <code>Arg</code> object. This non-visual component must be declared as
	 * a child component of a <code>MethodInvocation</code> component.
	 * @see org.springextensions.actionscript.context.support.mxml.MethodInvocation MethodInvocation
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class Arg extends AbstractMXMLObject {
		public static const LAZYPROPERTYRESOLVING_CHANGED_EVENT:String = "lazyPropertyResolvingChanged";
		public static const REF_CHANGED_EVENT:String = "refChanged";
		public static const TYPE_CHANGED_EVENT:String = "typeChanged";
		public static const VALUE_CHANGED_EVENT:String = "valueChanged";

		/**
		 * Creates a new <code>Arg</code> instance.
		 */
		public function Arg() {
			super(this);
		}

		private var _lazyPropertyResolving:Boolean;

		private var _ref:*;
		private var _type:String;
		private var _value:*;

		[Bindable(event="lazyPropertyResolvingChanged")]
		public function get lazyPropertyResolving():Boolean {
			return _lazyPropertyResolving;
		}

		public function set lazyPropertyResolving(value:Boolean):void {
			if (_lazyPropertyResolving != value) {
				_lazyPropertyResolving = value;
				dispatchEvent(new Event(LAZYPROPERTYRESOLVING_CHANGED_EVENT));
			}
		}

		[Bindable(event="refChanged")]
		/**
		 * A reference to another <code>ObjectDefinition</code> in the <code>MXMLApplicationContext</code> or the id of another <code>MXMLApplicationContext</code>.
		 */
		public function get ref():* {
			return _ref;
		}

		/**
		 * @private
		 */
		public function set ref(value:*):void {
			if (_ref != value) {
				_ref = value;
				dispatchEvent(new Event(REF_CHANGED_EVENT));
			}
		}

		[Inspectable(enumeration="class,boolean,number")]
		[Bindable(event="typeChanged")]
		/**
		 * This property can only have a value of 'class' or not be defined at all. When set to 'class' the argument
		 * value will be automatically be cast to type <code>Class</code>, but only if the value is of type <code>String</code>.
		 * An easier way of assigning a Class reference is like this: <code>&lt;sas:Arg name="propertyName" value={com.myclasses.MyCustomClass}/&gt;</code>
		 */
		public function get type():String {
			return _type;
		}

		/**
		 * @private
		 */
		public function set type(value:String):void {
			if (_type != value) {
				_type = value;
				dispatchEvent(new Event(TYPE_CHANGED_EVENT));
			}
		}

		[Bindable(event="valueChanged")]
		/**
		 * The value of the argument
		 */
		public function get value():* {
			return _value;
		}

		/**
		 * @private
		 */
		public function set value(value:*):void {
			if (_value != value) {
				_value = value;
				dispatchEvent(new Event(VALUE_CHANGED_EVENT));
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function clone():* {
			var clone:Arg = new Arg();
			clone.ref = this.ref;
			clone.type = this.type;
			clone.value = this.value;
			clone.lazyPropertyResolving = this.lazyPropertyResolving;
			return clone;
		}

		override public function initializeComponent(context:IApplicationContext, defaultDefinition:IBaseObjectDefinition):void {
			if (_value != null) {
				var objDef:MXMLObjectDefinition = (_value as MXMLObjectDefinition);
				if ((objDef != null) && (!objDef.isInitialized)) {
					objDef.initializeComponent(context, defaultDefinition);
				}
			}
			_isInitialized = true;
		}
	}
}
