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
package org.springextensions.actionscript.ioc.objectdefinition.impl {
	import org.as3commons.lang.ICloneable;
	import org.as3commons.lang.ObjectUtils;

	/**
	 * An object that describes how to invoke a specified method, determined by name, namespace and arguments.
	 * @author Christophe Herreman
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class MethodInvocation implements ICloneable {

		/**
		 * Creates a new <code>MethodInvocation</code> instance.
		 * @param methodName The name of the method that will be invoked.
		 * @param args Optional <code>Array</code> of arguments to be passed into the method invocation.
		 * @param ns Optional namespace URI for the method.
		 */
		public function MethodInvocation(methodName:String, args:Vector.<ArgumentDefinition>=null, ns:String=null) {
			super();
			_methodName = methodName;
			_arguments = args;
			_namespaceURI = ns;
		}

		private var _arguments:Vector.<ArgumentDefinition>;
		private var _methodName:String;
		private var _namespaceURI:String;
		private var _requiresDependencies:Boolean = true;
		private var _lazyPropertyResolving:Boolean;

		public function get lazyPropertyResolving():Boolean {
			return _lazyPropertyResolving;
		}

		public function set lazyPropertyResolving(value:Boolean):void {
			_lazyPropertyResolving = value;
		}

		/**
		 * Optional <code>Array</code> of arguments for the method invocation.
		 */
		public function get arguments():Vector.<ArgumentDefinition> {
			return _arguments;
		}

		/**
		 *  The name of the method that will be invoked.
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

		/**
		 * Optional namespace URI for the method.
		 */
		public function get namespaceURI():String {
			return _namespaceURI;
		}

		/**
		 * @private
		 */
		public function set namespaceURI(value:String):void {
			_namespaceURI = value;
		}

		/**
		 *
		 */
		public function get requiresDependencies():Boolean {
			return _requiresDependencies;
		}

		/**
		 * @private
		 */
		public function set requiresDependencies(value:Boolean):void {
			_requiresDependencies = value;
		}

		/**
		 * Returns an exact copy of the current <code>MethodInvocation</code>.
		 * @return An exact copy of the current <code>MethodInvocation</code>.
		 */
		public function clone():* {
			var newArguments:Vector.<ArgumentDefinition> = (_arguments != null) ? new Vector.<ArgumentDefinition>() : null;
			if (newArguments != null) {
				var len:int = _arguments.length;
				for(var i:int=0; i < len; ++i) {
					newArguments[newArguments.length] = _arguments[i].clone();
				}
			}
			var clone:MethodInvocation = new MethodInvocation(this.methodName, newArguments, this.namespaceURI);
			clone.requiresDependencies = this.requiresDependencies;
			clone.lazyPropertyResolving = this.lazyPropertyResolving;
			return clone;
		}


		/**
		 * Returns a string representation of the current <code>MethodInvocation</code>.
		 * @returns A string representation of the current <code>MethodInvocation</code>.
		 */
		public function toString():String {
			return "MethodInvocation{arguments:[" + _arguments + "], methodName:\"" + _methodName + "\", namespaceURI:\"" + _namespaceURI + "\", requiresDependencies:" + _requiresDependencies + ", lazyPropertyResolving:" + _lazyPropertyResolving + "}";
		}

	}
}
