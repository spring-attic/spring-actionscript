/*
* Copyright 2007-2012 the original author or authors.
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
package org.springextensions.actionscript.ioc.impl {
	import org.as3commons.lang.Assert;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public final class LazyDependencyCheckResult {

		private static const TYPES:Object = {};

		private static var _enumCreated:Boolean;

		public static const SATISFIED:LazyDependencyCheckResult = new LazyDependencyCheckResult("satisfied");
		public static const UNSATISFIED:LazyDependencyCheckResult = new LazyDependencyCheckResult("unsatisfied");
		public static const UNSATISFIED_LAZY:LazyDependencyCheckResult = new LazyDependencyCheckResult("unsatisfiedlazy");

		private var _name:String;

		{
			_enumCreated = true;
		}

		/**
		 * Creates a new <code>LazyDependencyCheckResult</code> instance.
		 */
		public function LazyDependencyCheckResult(val:String) {
			Assert.state(!_enumCreated, "LazyDependencyCheckResult enum has already been created");
			super();
			_name = val;
			TYPES[_name] = this;
		}

		/**
		 *
		 * @param val
		 * @return
		 */
		public static function fromValue(val:String):LazyDependencyCheckResult {
			val ||= "";
			return TYPES[val.toLowerCase()];
		}

		/**
		 *
		 * @return
		 */
		public function toString():String {
			return _name;
		}
	}
}
