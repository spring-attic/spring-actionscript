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
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNull;
	import org.springextensions.actionscript.context.impl.DefaultApplicationContext;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.XMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.MethodInvocation;

	public class CompositeCommandNodeParserTest {

		private var _nodeParser:CompositeCommandNodeParser;

		private var _testXML:XML = <composite-command kind="parallel" fail-on-fault="true"><object id="object1"/><object id="object2"/><object id="object3"/></composite-command>;


		public function CompositeCommandNodeParserTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_nodeParser = new CompositeCommandNodeParser();
		}

		[Test]
		public function testParse():void {
			var result:IObjectDefinition = _nodeParser.parse(_testXML, new XMLObjectDefinitionsParser(new DefaultApplicationContext()));
			assertEquals("org.as3commons.async.command.impl.CompositeCommand", result.className);
			assertNull(result.constructorArguments);
			assertEquals(3, result.methodInvocations.length);
			assertEquals("object1", result.methodInvocations[0].arguments[0].ref.objectName);
			assertEquals("object2", result.methodInvocations[1].arguments[0].ref.objectName);
			assertEquals("object3", result.methodInvocations[2].arguments[0].ref.objectName);
		}

	}
}
