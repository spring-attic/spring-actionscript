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


	public class SpringNamesPreprocessorTest {

		public function SpringNamesPreprocessorTest() {
			super();
		}

		[Test]
		public function testPreprocess():void {
			var input:XML = new XML('<beans><bean/></beans>');
			var processor:IXMLObjectDefinitionsPreprocessor = new SpringNamesPreprocessor();
			input = processor.preprocess(input);
			assertEquals("objects", input.localName());
			assertEquals("object", input.children()[0].localName());
		}
	}
}
