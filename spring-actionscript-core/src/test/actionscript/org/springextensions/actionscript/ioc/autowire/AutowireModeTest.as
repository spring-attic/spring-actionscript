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
package org.springextensions.actionscript.ioc.autowire {
	import org.flexunit.asserts.assertStrictlyEquals;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class AutowireModeTest {

		/**
		 * Creates a new <code>AutowireModeTest</code> instance.
		 */
		public function AutowireModeTest() {
			super();
		}

		[Test(expects="org.as3commons.lang.IllegalStateError")]
		public function testConstructorError():void {
			new AutowireMode("none");
		}

		[Test]
		public function testFromName():void {
			var testMode:AutowireMode;

			testMode = AutowireMode.fromName("no");
			assertStrictlyEquals(AutowireMode.NO, testMode);

			testMode = AutowireMode.fromName("byName");
			assertStrictlyEquals(AutowireMode.BYNAME, testMode);

			testMode = AutowireMode.fromName("byType");
			assertStrictlyEquals(AutowireMode.BYTYPE, testMode);

			testMode = AutowireMode.fromName("constructor");
			assertStrictlyEquals(AutowireMode.CONSTRUCTOR, testMode);

			testMode = AutowireMode.fromName("autodetect");
			assertStrictlyEquals(AutowireMode.AUTODETECT, testMode);

			testMode = AutowireMode.fromName("unknown");
			assertStrictlyEquals(AutowireMode.NO, testMode);

			testMode = AutowireMode.fromName(null);
			assertStrictlyEquals(AutowireMode.NO, testMode);
		}

	}
}
