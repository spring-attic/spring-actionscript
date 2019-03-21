/*
 * Copyright 2007-2010 the original author or authors.
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
package org.springextensions.actionscript.ioc.config.impl.xml.preprocess.impl {
	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.verify;

	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.config.property.IPropertiesProvider;

	public class PropertyElementsPreprocessorTest {

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var propertiesProvider:IPropertiesProvider;

		public function PropertyElementsPreprocessorTest() {
			super();
		}

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testIllegalConstructor():void {
			var proc:PropertyElementsPreprocessor = new PropertyElementsPreprocessor(null);
		}

		[Test]
		public function testPreprocess():void {
			var xml:XML = <objects>
					<property name="key1" value="val1"/>
					<property name="key2" value="val2"/>
					<property name="key3" value="val3"/>
					<property name="key4" value="val4"/>
					<property file="properties.txt"/>
					<property file="properties.txt" name="key5" value="val5"/>
				</objects>;
			propertiesProvider = nice(IPropertiesProvider);
			mock(propertiesProvider).method("setProperty").args("key1", "val1");
			mock(propertiesProvider).method("setProperty").args("key2", "val2");
			mock(propertiesProvider).method("setProperty").args("key3", "val3");
			mock(propertiesProvider).method("setProperty").args("key4", "val4");
			var proc:PropertyElementsPreprocessor = new PropertyElementsPreprocessor(propertiesProvider);

			proc.preprocess(xml);
			verify(propertiesProvider);
		}

	}
}
