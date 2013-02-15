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
package org.springextensions.actionscript.ioc.factory.xml.preprocessors {
	import org.springextensions.actionscript.collections.Properties;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.support.AbstractApplicationContext;
	import org.springextensions.actionscript.flexunit.FlexUnitTestCase;
	import org.springextensions.actionscript.ioc.util.Constants;

	public class PropertyElementsPreprocessorTest extends FlexUnitTestCase {

		public function PropertyElementsPreprocessorTest(methodName:String = null) {
			super(methodName);
		}

		public function testIllegalConstructor():void {
			try {
				var proc:PropertyElementsPreprocessor = new PropertyElementsPreprocessor(null);
				fail("ConfigPropertyElementsPreprocessor construction should fail with a constructor arg that is null");
			}
			catch(e:*) {
				assertTrue(true);
			}
		}
		
		public function testPreprocess():void {
			var xml:XML = <objects>
							<property name="key1" value="val1"/>
							<property name="key2" value="val2"/>
							<property name="key3" value="val3"/>
							<property name="key4" value="val4"/>
							<property file="properties.txt"/>
							<property file="properties.txt" name="key5" value="val5"/>
						</objects>;
			var factory:IApplicationContext = new AbstractApplicationContext();
			var proc:PropertyElementsPreprocessor = new PropertyElementsPreprocessor(factory);

			proc.preprocess(xml);
			
			var props:Properties = factory.properties;
			
			assertNotNull(props);
			
			assertEquals(4, props.propertyNames.length);

			assertEquals("val1",props.getProperty("key1"));
			assertEquals("val2",props.getProperty("key2"));
			assertEquals("val3",props.getProperty("key3"));
			assertEquals("val4",props.getProperty("key4"));
		}

	}
}