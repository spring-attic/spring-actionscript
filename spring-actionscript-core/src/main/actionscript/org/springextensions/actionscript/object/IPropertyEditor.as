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
package org.springextensions.actionscript.object {

	/**
	 * A property editor converts strings to typed objects.
	 * Typically these strings are found in the Spring Actionscript configuration XML.
	 * @author Christophe Herreman
	 * @productionversion SpringActionscript 2.0
	 */
	public interface IPropertyEditor {

		/**
		 * The string that will be converted into an object. For example: org.springextensions.actionscript.collections.TypedCollection
		 */
		function get text():String;
		/**
		 * @private
		 */
		function set text(value:String):void;

		/**
		 * The result of the string-to-object conversion.
		 */
		function get value():*;
		/**
		 * @private
		 */
		function set value(v:*):void;
	}
}
