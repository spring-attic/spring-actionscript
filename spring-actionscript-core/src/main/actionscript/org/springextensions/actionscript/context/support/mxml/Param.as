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
	import org.as3commons.reflect.AbstractMember;

	/**
	 * MXML representation of an <code>Param</code> object. This non-visual component must be declared as
	 * a child component of a <code>ObjectDefinition</code> component.
	 * The value of a <code>Param</code> instance will be replaced in the definition of a <code>Template</code>
	 * using the name of the <code>Param</code> as a placeholder name, formatted like this: '#' + <code>Param.name</code> + '#'.
	 * @see org.springextensions.actionscript.context.support.mxml.MXMLObjectDefinition ObjectDefinition
	 * @see org.springextensions.actionscript.context.support.mxml.Template Template
	 * @docref container-documentation.html#composing_mxml_based_configuration_metadata
	 * @author Roland Zwaga
	 */
	public class Param extends AbstractMXMLObject {
		
		/**
		 * Creates a new <code>Param</code> instance 
		 */
		public function Param()	{
			super(this);
		}
		
		private var _name:String;
		/**
		 * The name of the parameter. This is also the name of the placeholder in the <code>Template</code>.
		 * For example, when the <code>Param</code> name is 'myParam' there ought to be a placeholder called '#myParam#' present
		 * in the <code>Template</code> definition.
		 * @see org.springextensions.actionscript.context.support.mxml.Template Template
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
		
		private var _value:*;
		/**
		 * The value that will be used for placeholder substitution in the <code>Template</code> definition.
		 * @see org.springextensions.actionscript.context.support.mxml.Template Template
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
		
		/**
		 * @inheritDoc 
		 */
		override public function clone():*{
			var clone:Param = new Param();
			clone.name = this.name;
			clone.value = this.value;
			return clone;
		}

	}
}