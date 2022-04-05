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
package org.springextensions.actionscript.ioc.config.impl.mxml.component {
	import org.flexunit.asserts.assertEquals;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class InterfaceTest {
		/**
		 * Creates a new <code>InterfaceTest</code> instance.
		 */
		public function InterfaceTest() {
			super();
		}

		[Test]
		public function testIsInterface():void {
			var intf:Interface = new Interface();
			intf.initializeComponent(null, null);
			intf.parse();
			assertEquals(true, intf.definition.isInterface);
		}
	}
}
