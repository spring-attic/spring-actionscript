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
package org.springextensions.actionscript.ioc {

	/**
	 * 
	 * @author Christophe Herreman
	 * 
	 */
	public class MethodInvocation extends Object {

		private var _methodName:String;
		private var _arguments:Array;

		/**
		 * Creates a new <code>MethodInvocation</code> instance.
		 * @param methodName The name of the method that needs to be invoked.
		 * @param args Optional array of arguments for the method invocation.
		 * 
		 */
		public function MethodInvocation(methodName:String, args:Array = null) {
			super();
			_methodName = methodName;
			_arguments = args;
		}

		/**
		 *  The name of the method that needs to be invoked.
		 */
		public function get methodName():String {
			return _methodName;
		}

		/**
		 * Optional array of arguments for the method invocation.
		 */
		public function get arguments():Array {
			return _arguments;
		}
	}
}