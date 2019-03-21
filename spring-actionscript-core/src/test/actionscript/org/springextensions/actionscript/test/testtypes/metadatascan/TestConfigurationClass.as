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
package org.springextensions.actionscript.test.testtypes.metadatascan {

	[Configuration]
	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class TestConfigurationClass {

		/**
		 * Creates a new <code>TestConfigurationClass</code> instance.
		 */
		public function TestConfigurationClass() {
			super();
		}

		[Property(name="someProperty", ref="objectName1")]
		[Property(name="someOtherProperty", ref="objectName2")]
		public var component1:AnnotatedComponentWithPropertiesWithRefs;

		[Invoke(name="someFunction", args="ref=objectName1, value=10")]
		[Invoke(name="someOtherFunction", args="ref=objectName2")]
		public var component2:AnnotatedComponentWithMethodInvocations;

		[Constructor(args="ref=objectName1")]
		public var component3:AnnotatedComponentWithConstructor;

		[Component(id="annotatedNamedComponent2")]
		public var component4:AnnotatedNamedComponent2;

		[Ignore]
		[Test]
		public function testDummy():void {
		}
	}
}
