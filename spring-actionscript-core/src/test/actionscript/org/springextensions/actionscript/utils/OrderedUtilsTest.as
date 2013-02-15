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
package org.springextensions.actionscript.utils {
	import flexunit.framework.TestCase;

	import org.springextensions.actionscript.utils.testclasses.OrderedTest;

	public class OrderedUtilsTest extends TestCase {

		public function OrderedUtilsTest(methodName:String = null) {
			super(methodName);
		}

		public function testSortOrderedArray():void {
			var collection:Array = new Array(5);
			var object1:Object = {};
			var object2:Object = {};
			var ordered1:Object = new OrderedTest(0);
			var ordered2:Object = new OrderedTest(1);
			var ordered3:Object = new OrderedTest(2);

			collection[0] = object2;
			collection[1] = ordered1;
			collection[2] = object1;
			collection[3] = ordered3;
			collection[4] = ordered2;

			collection = OrderedUtils.sortOrderedArray(collection);

			assertEquals(5, collection.length);
			assertStrictlyEquals(ordered1, collection[0]);
			assertStrictlyEquals(ordered2, collection[1]);
			assertStrictlyEquals(ordered3, collection[2]);

		}
	}
}