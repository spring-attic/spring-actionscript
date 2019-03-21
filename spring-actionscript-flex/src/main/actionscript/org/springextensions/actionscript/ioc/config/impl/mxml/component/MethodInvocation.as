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
	import mx.utils.UIDUtil;
	
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.objectdefinition.IBaseObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ArgumentDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.MethodInvocation;

	[DefaultProperty("arguments")]
	/**
	 * MXML representation of a <code>MethodInvocation</code> object. This non-visual component must be declared as
	 * a child component of a <code>ObjectDefinition</code> component.
	 * @see org.springextensions.actionscript.context.support.mxml.MXMLObjectDefinition ObjectDefinition
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class MethodInvocation extends AbstractMXMLObject {

		/**
		 * Creates a new <code>MethodInvocation</code> instance.
		 */
		public function MethodInvocation() {
			super(this);
			_arguments = [];
		}

		private var _arguments:Array;
		private var _methodName:String;
		private var _namespaceURI:String;

		/**
		 * An array of <code>Arg</code> objects that define the arguments that need to be used for the method's invocation.
		 */
		public function get arguments():Array {
			return _arguments;
		}

		/**
		 * @private
		 */
		public function set arguments(value:Array):void {
			_arguments = value;
		}

		/**
		 * The name of the method that will be invoked.
		 */
		public function get methodName():String {
			return _methodName;
		}

		/**
		 * @private
		 */
		public function set methodName(value:String):void {
			_methodName = value;
		}


		public function get namespaceURI():String {
			return _namespaceURI;
		}

		public function set namespaceURI(value:String):void {
			_namespaceURI = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function clone():* {
			var clone:MethodInvocation = new MethodInvocation();
			clone.id = UIDUtil.createUID();
			clone.methodName = this.methodName;
			clone.namespaceURI = this.namespaceURI;
			for each (var arg:Arg in _arguments) {
				clone.arguments[clone.arguments.length] = arg.clone();
			}
			return clone;
		}

		/**
		 * @inheritDoc
		 */
		override public function initialized(document:Object, id:String):void {
			super.initialized(document, id);
		}

		public function toMethodInvocation(context:IApplicationContext, defaultDefinition:IBaseObjectDefinition=null):org.springextensions.actionscript.ioc.objectdefinition.impl.MethodInvocation {
			var args:Vector.<ArgumentDefinition>;
			for each (var arg:Arg in _arguments) {
				args ||= new Vector.<ArgumentDefinition>();
				arg.initializeComponent(context, defaultDefinition);
				args[args.length] = ArgumentDefinition.newInstance((arg.ref != null) ? arg.ref : arg.value, arg.lazyPropertyResolving);
			}
			return new org.springextensions.actionscript.ioc.objectdefinition.impl.MethodInvocation(_methodName, args, _namespaceURI);
		}
	}
}
