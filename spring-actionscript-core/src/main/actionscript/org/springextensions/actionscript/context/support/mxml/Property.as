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
	
	import org.springextensions.actionscript.collections.Properties;

	[DefaultProperty("value")]
	/**
	 * MXML representation of a <code>Property</code> object. This non-visual component must be declared as
	 * a child component of a <code>ObjectDefinition</code> component.
	 * @see org.springextensions.actionscript.context.support.mxml.MXMLObjectDefinition ObjectDefinition
	 * @docref container-documentation.html#composing_mxml_based_configuration_metadata
  	 * @author Roland Zwaga
	 */
	public class Property extends Arg {
		
		/**
		 * Creates a new <code>Property</code> instance 
		 */
		public function Property() {
			super();
		}
		
		private var _name:String;
		/**
		 * The name of the property 
		 */
		public function get name():String{
			return _name;
		}
		/**
		 * @private
		 */
		public function set name(value:String):void{
			_name = value;
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function clone():*{
			var clone:Property = new Property();
			clone.name = this.name;
			clone.ref = this.ref;
			clone.type = this.type;
			clone.value = this.value;
			return clone;
		}
		
	}
}