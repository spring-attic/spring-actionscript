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
package org.springextensions.actionscript.ioc.error {

	import org.as3commons.lang.ClassNotFoundError;

	/**
	 * <p>Most of the time this error is thrown because the required class isn't properly referenced
	 * in the application source code. Follow the documentation reference in order to read more about this problem
	 * and how to solve it.</p>
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 * @docref class-inclusion.html
	 */
	public class ObjectContainerError extends ClassNotFoundError {

		public var objectName:String;

		/**
		 * Creates a new <code>ObjectContainerError</code> instance.
		 */
		public function ObjectContainerError(message:*="", objName:String="") {
			message += "\nobject definition name:" + objName + "\n Are you sure the specified class has been compiled?\n Look for more information on this topic here:\nhttp://www.springactionscript.org/docs/reference/html/class-inclusion.html";
			super(message);
		}
	}
}
