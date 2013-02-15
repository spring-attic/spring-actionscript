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
package org.springextensions.actionscript.core.io {

	import org.springextensions.actionscript.core.operation.IOperation;

	/**
	 * Interface to be implemented by classes that need to load a resource (xml, text, properties, ...) asynchronously.
	 *
	 * @author Christophe Herreman
	 */
	public interface IResourceLoader {

		/**
		 * Loads the resource asynchronously and returns an operation that invokers can listen to.
		 *
		 * @return an operation for the load operation
		 */
		function load():IOperation;

	}
}