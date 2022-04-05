/*
 * Copyright 2007-2008 the original author or authors.
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

	import mockolate.runner.MockolateRule;

	import org.as3commons.lang.IllegalArgumentError;
	import org.flexunit.asserts.assertTrue;
	import org.springextensions.actionscript.ioc.config.impl.xml.preprocess.IXMLObjectDefinitionsPreprocessor;

	/**
	 * @author Christophe Herreman
	 */
	public class IdAttributePreprocessorTest {

		private var _preprocessor:IXMLObjectDefinitionsPreprocessor;

		public function IdAttributePreprocessorTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_preprocessor = new IdAttributePreprocessor();
		}

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testPreprocess_shouldThrowIllegalArgumentErrorWhenXMLIsNull():void {
			_preprocessor.preprocess(null);
		}

		[Test]
		public function testPreprocessWithNoId():void {
			var xml:XML = <objects>
					<object/>
				</objects>;
			var xmlProcessed:XML = _preprocessor.preprocess(xml);
			assertTrue(xmlProcessed.object[0].@id !== undefined);
		}

		[Test]
		public function testPreprocessWithNoIdWithNestedNodes():void {
			var xml:XML = <objects>
					<object>
						<object/>
					</object>
				</objects>;
			var xmlProcessed:XML = _preprocessor.preprocess(xml);
			assertTrue(xmlProcessed.object[0].@id != undefined);
			assertTrue(xmlProcessed.object[0].object[0].@id != undefined);
		}

	}
}
