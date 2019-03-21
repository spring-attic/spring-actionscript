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
package org.springextensions.actionscript.security {
	import flash.events.IEventDispatcher;

	/**
	 * Describes an object that hold a list of role and right names.
	 * @author Roland Zwaga
	 */
	public interface IMembershipOwner extends IEventDispatcher {

		/**
		 * A Vector of strings that represent the role names that are applicable to the current <code>IMembershipOwner</code>
		 */
		function get roles():Vector.<String>;
		/**
		 * @private
		 */
		function set roles(value:Vector.<String>):void;

		/**
		 * A Vector of strings that represent the right names that are applicable to the current <code>IMembershipOwner</code>
		 */
		function get rights():Vector.<String>;
		/**
		 * @private
		 */
		function set rights(value:Vector.<String>):void;

	}
}
