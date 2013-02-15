/*
 * Copyright 2007-2008 the original author or authors.
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
	
	import flexunit.framework.TestCase;
	
	import org.as3commons.lang.IllegalArgumentError;
	import org.springextensions.actionscript.ioc.factory.xml.parser.IXMLObjectDefinitionsPreprocessor;
	
	/**
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public class IdAttributePreprocessorTest extends TestCase {
		
		private var _preprocessor:IXMLObjectDefinitionsPreprocessor;
		
		public function IdAttributePreprocessorTest(methodName:String = null) {
			super(methodName);
		}
		
		override public function setUp():void {
			_preprocessor = new IdAttributePreprocessor();
		}
		
		public function testPreprocess_shouldThrowIllegalArgumentErrorWhenXMLIsNull():void {
			try {
				_preprocessor.preprocess(null);
				fail("Calling 'preprocess' with null argument should fail");
			} catch (e:IllegalArgumentError) {
			}
		}
		
		public function testPreprocessWithNoId():void {
			var xml:XML =    <objects>
					<object/>
				</objects>;
			var xmlProcessed:XML = _preprocessor.preprocess(xml);
			assertNotUndefined(xmlProcessed.object[0].@id);
		}
	
	}
}
