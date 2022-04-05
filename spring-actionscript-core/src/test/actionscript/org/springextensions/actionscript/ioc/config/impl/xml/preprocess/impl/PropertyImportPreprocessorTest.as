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
	import mockolate.nice;
	import mockolate.runner.MockolateRule;

	import org.as3commons.lang.IllegalArgumentError;
	import org.flexunit.asserts.assertEquals;
	import org.springextensions.actionscript.ioc.config.impl.xml.preprocess.IXMLObjectDefinitionsPreprocessor;
	import org.springextensions.actionscript.ioc.config.property.IPropertiesProvider;
	import org.springextensions.actionscript.ioc.config.property.TextFileURI;


	public class PropertyImportPreprocessorTest {

		public function PropertyImportPreprocessorTest() {
			super();
		}

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testIllegalConstructor():void {
			var processor:IXMLObjectDefinitionsPreprocessor = new PropertyImportPreprocessor(null);
		}

		[Test]
		public function testPreprocessWithOnePropertyElementWithOnlyFileAttribute():void {
			var input:XML = new XML("<objects><property file='file.txt'/></objects>");
			var uris:Vector.<TextFileURI> = new Vector.<TextFileURI>();
			var processor:IXMLObjectDefinitionsPreprocessor = new PropertyImportPreprocessor(uris);
			processor.preprocess(input);
			assertEquals(1, uris.length);
			assertEquals('file.txt', uris[0].textFileURI);
			assertEquals(true, uris[0].isRequired);
			assertEquals(true, uris[0].preventCache);
			assertEquals(0, input.property.length());
		}

		[Test]
		public function testPreprocessWithTwoPropertyElementsFirstWithFileAttribute():void {
			var input:XML = new XML("<objects><property file='file.txt'/><property name='key' value='value'/></objects>");
			var uris:Vector.<TextFileURI> = new Vector.<TextFileURI>();
			var processor:IXMLObjectDefinitionsPreprocessor = new PropertyImportPreprocessor(uris);
			processor.preprocess(input);
			assertEquals(1, uris.length);
			assertEquals('file.txt', uris[0].textFileURI);
			assertEquals(true, uris[0].isRequired);
			assertEquals(true, uris[0].preventCache);
			assertEquals(1, input.property.length());
			assertEquals(0, input.property.(attribute("file") != undefined).length());
		}

		[Test]
		public function testPreprocessWithTwoPropertyElementsSecondWithFileAttribute():void {
			var input:XML = new XML("<objects><property name='key' value='value'/><property file='file.txt'/></objects>");
			var uris:Vector.<TextFileURI> = new Vector.<TextFileURI>();
			var processor:IXMLObjectDefinitionsPreprocessor = new PropertyImportPreprocessor(uris);
			processor.preprocess(input);
			assertEquals(1, uris.length);
			assertEquals('file.txt', uris[0].textFileURI);
			assertEquals(true, uris[0].isRequired);
			assertEquals(true, uris[0].preventCache);
			assertEquals(1, input.property.length());
			assertEquals(0, input.property.(attribute("file") != undefined).length());
		}

		[Test]
		public function testPreprocessWithOnePropertyElementFileAndCacheAndRequiredAttribute():void {
			var input:XML = new XML("<objects><property file='file.txt' required='false' prevent-cache='false'/></objects>");
			var uris:Vector.<TextFileURI> = new Vector.<TextFileURI>();
			var processor:IXMLObjectDefinitionsPreprocessor = new PropertyImportPreprocessor(uris);
			processor.preprocess(input);
			assertEquals(1, uris.length);
			assertEquals('file.txt', uris[0].textFileURI);
			assertEquals(false, uris[0].isRequired);
			assertEquals(false, uris[0].preventCache);
		}

	}
}
