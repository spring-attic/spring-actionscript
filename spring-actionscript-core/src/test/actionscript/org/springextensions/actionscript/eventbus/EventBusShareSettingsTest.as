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
package org.springextensions.actionscript.eventbus {
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class EventBusShareSettingsTest {

		/**
		 * Creates a new <code>EventBusShareSettingsTest</code> instance.
		 */
		public function EventBusShareSettingsTest() {
			super();
		}

		[Test]
		public function testDefaultPropertyValues():void {
			var settings:EventBusShareSettings = new EventBusShareSettings();
			assertTrue(settings.shareRegularEvents);
			assertStrictlyEquals(EventBusShareKind.ASSIGN_PARENT_EVENTBUS, settings.shareKind);
			assertNull(settings.sharedTopics);
		}
	}
}
