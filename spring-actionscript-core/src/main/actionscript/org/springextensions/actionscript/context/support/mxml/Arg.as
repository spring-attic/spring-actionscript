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
package org.springextensions.actionscript.context.support.mxml {
	
	[DefaultProperty("value")]
	/**
	 * MXML representation of an <code>Arg</code> object. This non-visual component must be declared as
	 * a child component of a <code>MethodInvocation</code> component.
	 * @see org.springextensions.actionscript.context.support.mxml.MethodInvocation MethodInvocation
  	 * @author Roland Zwaga
  	 * @docref container-documentation.html#composing_mxml_based_configuration_metadata
	 */
	public class Arg extends AbstractMXMLObject	{
		
		/**
		 * Creates a new <code>Arg</code> instance. 
		 */
		public function Arg() {
			super(this);
		}

		private var _value:*;
		/**
		 * The value of the argument 
		 */
		public function get value():*{
			return _value;
		}
		/**
		 * @private 
		 */
		public function set value(v:*):void{
			_value = v;
		}

		private var _type:String;
		/**
		 * This property can only have a value of 'class' or not be defined at all. When set to 'class' the argument
		 * value will be automatically be cast to type <code>Class</code>, but only if the value is of type <code>String</code>.
		 * An easier way of assigning a Class reference is like this: <code>&lt;sas:Arg name="propertyName" value={com.myclasses.MyCustomClass}/&gt;</code>
		 */
		[Inspectable(enumeration="class")]
		public function get type():String{
			return _type;
		}
		/**
		 * @private
		 */
		public function set type(value:String):void{
			_type = value;
		}
		
		private var _ref:MXMLObjectDefinition;
		/**
		 * A reference to another <code>ObjectDefinition</code> in the <code>MXMLApplicationContext</code> 
		 */
		public function get ref():MXMLObjectDefinition{
			return _ref;
		}
		/**
		 * @private
		 */
		public function set ref(value:MXMLObjectDefinition):void{
			_ref = value;
		}
		
		override public function initializeComponent():void {
			if (_value != null) {
				var objDef:MXMLObjectDefinition = (_value as MXMLObjectDefinition);
				if ((objDef != null)&&(!objDef.isInitialized)) {
					objDef.initializeComponent();
				}
			}
			_isInitialized = true;
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function clone():*{
			var clone:Arg = new Arg();
			clone.ref = this.ref;
			clone.type = this.type;
			clone.value = this.value;
			return clone;
		}
		
	}
}