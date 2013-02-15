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
package org.springextensions.actionscript.core.task.xml.parser {
	import flexunit.framework.TestCase;

	import org.springextensions.actionscript.core.io.support.LoadURLStreamOperation;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;

	public class LoadURLStreamNodeParserTest extends TestCase {

		private var _nodeParser:LoadURLStreamNodeParser;

		private var _testXML:XML = <load-url-stream url="resource.swf"/>;

		public function LoadURLStreamNodeParserTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			_nodeParser = new LoadURLStreamNodeParser();
		}

		public function testParse():void {
			var result:IObjectDefinition = _nodeParser.parse(_testXML, new XMLObjectDefinitionsParser());
			assertEquals("org.springextensions.actionscript.core.command.GenericOperationCommand", result.className);
			assertEquals(2, result.constructorArguments.length);
			assertStrictlyEquals(LoadURLStreamOperation, result.constructorArguments[0]);
			assertEquals("resource.swf", result.constructorArguments[1]);
		}

	}
}