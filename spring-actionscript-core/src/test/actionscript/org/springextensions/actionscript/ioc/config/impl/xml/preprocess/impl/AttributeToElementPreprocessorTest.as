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
package org.springextensions.actionscript.ioc.config.impl.xml.preprocess.impl {
	import org.flexunit.asserts.assertEquals;
	import org.springextensions.actionscript.ioc.config.impl.xml.preprocess.IXMLObjectDefinitionsPreprocessor;


	public class AttributeToElementPreprocessorTest {

		public function AttributeToElementPreprocessorTest() {
			super();
		}

		[Test]
		public function testPreProcessWithValueAttribute():void {
			var input:XML = new XML("<objects><object value='myValue'/></objects>");
			var preprocesser:IXMLObjectDefinitionsPreprocessor = new AttributeToElementPreprocessor();
			input = preprocesser.preprocess(input);
			var element:XML = input.children()[0];
			assertEquals(1, element.children().length());
			assertEquals("value", element.children()[0].localName());
			assertEquals("myValue", element.children()[0]);
		}

		[Test]
		public function testPreProcessWithRefAttribute():void {
			var input:XML = new XML("<objects><object ref='myRef'/></objects>");
			var preprocesser:IXMLObjectDefinitionsPreprocessor = new AttributeToElementPreprocessor();
			input = preprocesser.preprocess(input);
			var element:XML = input.children()[0];
			assertEquals(1, element.children().length());
			assertEquals("ref", element.children()[0].localName());
			assertEquals("myRef", element.children()[0]);
		}

		[Test]
		public function testPreProcessWithValueAttributeAndRefAttribute():void {
			var input:XML = new XML("<objects><object value='myValue' ref='myRef' class='com.classes.MyClass'/></objects>");
			var preprocesser:IXMLObjectDefinitionsPreprocessor = new AttributeToElementPreprocessor();
			input = preprocesser.preprocess(input);
			var element:XML = input.children()[0];
			assertEquals(2, element.children().length());
			assertEquals("value", element.children()[0].localName());
			assertEquals("myValue", element.children()[0]);
			assertEquals("ref", element.children()[1].localName());
			assertEquals("myRef", element.children()[1]);
			assertEquals("com.classes.MyClass", element.attribute("class")[0]);
		}
	}
}
