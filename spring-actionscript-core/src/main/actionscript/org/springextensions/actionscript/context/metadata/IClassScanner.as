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
package org.springextensions.actionscript.context.metadata {

	/**
	 * Describes an object that examines one or more classes and performs custom logic accordingly.
	 *
	 * @author Roland Zwaga
	 * @author Christophe Herreman
	 * @docref componentscan.html
	 * @sampleref movie-app-metadata
	 */
	public interface IClassScanner {

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		/**
		 * A list of metdata names that a class needs to be annotated with for the current <code>IClassScanner</code>
		 * to be invoked.
		 */
		function get metaDataNames():Array;

		// --------------------------------------------------------------------
		//
		// Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Performs the scanning logic for the specified class name.
		 * @param className The specified class name.
		 */
		function scan(className:String):void;

		/**
		 * Performs the scanning logic for the specified class names.
		 * @param classNames
		 */
		function scanClassNames(classNames:Array):void;
	}
}