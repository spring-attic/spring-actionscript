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
package org.springextensions.actionscript.module {

	import mx.modules.Module;
	
	/**
	 * Describes an object that needs a reference to a <code>Module</code> that it is associated with.
	 *
	 * @author Roland Zwaga
	 */
	public interface IOwnerModuleAware {

		/**
		 * The <code>Module</code> that will act as the owner of the current <code>IOwnerModuleAware</code> instance.
		 */
		function get ownerModule():Module;

		/**
		 * @private
		 */
		function set ownerModule(value:Module):void;
	}
}