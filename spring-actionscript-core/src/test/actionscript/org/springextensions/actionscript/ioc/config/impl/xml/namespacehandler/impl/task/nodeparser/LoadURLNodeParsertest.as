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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser {
	import org.as3commons.async.operation.impl.LoadURLOperation;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.springextensions.actionscript.context.impl.DefaultApplicationContext;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.XMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;

	public class LoadURLNodeParsertest {

		private var _nodeParser:LoadURLNodeParser;

		private var _testXML:XML = <load-url url="resource.swf" data-format="binary"/>;

		public function LoadURLNodeParsertest() {
			super();
		}

		[Before]
		public function setUp():void {
			_nodeParser = new LoadURLNodeParser();
		}

		[Test]
		public function testParse():void {
			var result:IObjectDefinition = _nodeParser.parse(_testXML, new XMLObjectDefinitionsParser(new DefaultApplicationContext()));
			assertEquals("org.as3commons.async.command.impl.GenericOperationCommand", result.className);
			assertEquals(3, result.constructorArguments.length);
			assertStrictlyEquals(LoadURLOperation, result.constructorArguments[0].value);
			assertEquals("resource.swf", result.constructorArguments[1].value);
			assertEquals("binary", result.constructorArguments[2].value);
		}

	}
}
