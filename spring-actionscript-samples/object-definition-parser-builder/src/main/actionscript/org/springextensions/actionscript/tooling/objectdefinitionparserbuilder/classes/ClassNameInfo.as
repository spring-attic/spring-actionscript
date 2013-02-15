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
package org.springextensions.actionscript.tooling.objectdefinitionparserbuilder.classes {

	/**
	 * Class that contains some basic information about an arbitrary class
	 * @author Roland Zwaga
	 */
	public final class ClassNameInfo {
		private var _name:String;

		/**
		 * The name of the referenced class 
		 */
		public function get name():String {
			return _name;
		}

		private var _fullyQualifiedName:String;

		/**
		 * The fully qualified name of the referenced class
		 */
		public function get fullyQualifiedName():String {
			return _fullyQualifiedName;
		}

		/**
		 * Creates a new <code>ClassNameInfo</code> instance
		 * @param className
		 * @param classFullyQualifiedName
		 */
		public function ClassNameInfo(className:String, classFullyQualifiedName:String) {
			_name=className;
			_fullyQualifiedName=classFullyQualifiedName;
		}

	}
}