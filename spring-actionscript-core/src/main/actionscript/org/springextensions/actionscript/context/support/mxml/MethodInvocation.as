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
package org.springextensions.actionscript.context.support.mxml {
	import mx.utils.UIDUtil;
	
	[DefaultProperty("arguments")]
	/**
	 * MXML representation of a <code>MethodInvocation</code> object. This non-visual component must be declared as
	 * a child component of a <code>ObjectDefinition</code> component.
	 * @see org.springextensions.actionscript.context.support.mxml.MXMLObjectDefinition ObjectDefinition
	 * @author Roland Zwaga
	 * @docref container-documentation.html#composing_mxml_based_configuration_metadata
	 */
	public class MethodInvocation extends AbstractMXMLObject {
		
		/**
		 * Creates a new <code>MethodInvocation</code> instance.
		 */
		public function MethodInvocation()	{
			super(this);
			_arguments = [];
		}

		/**
		 * @inheritDoc
		 */
		override public function initialized(document:Object, id:String):void
		{
			super.initialized(document,id);
		}
		
		private var _methodName:String;
		/**
		 * The name of the method that will be invoked.
		 */
		public function get methodName():String{
			return _methodName;
		}
		/**
		 * @private
		 */
		public function set methodName(value:String):void{
			_methodName = value;
		}
		
		private var _arguments:Array;
		/**
		 * An array of <code>Arg</code> objects that define the arguments that need to be used for the method's invocation. 
		 */		
		public function get arguments():Array{
			return _arguments;
		}
		/**
		 * @private
		 */
		public function set arguments(value:Array):void{
			_arguments = value;
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function clone():*{
			var clone:MethodInvocation = new MethodInvocation();
			clone.id = UIDUtil.createUID();
			clone.methodName = this.methodName;
			for each (var arg:Arg in _arguments){
				clone.arguments.push(arg.clone());
			}
			return clone;
		}

		
	}
}