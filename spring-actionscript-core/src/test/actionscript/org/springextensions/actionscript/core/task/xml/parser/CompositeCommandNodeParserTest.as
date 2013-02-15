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
	
	import org.springextensions.actionscript.core.command.CompositeCommand;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.MethodInvocation;
	import org.springextensions.actionscript.ioc.factory.config.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;

	public class CompositeCommandNodeParserTest extends TestCase {

		private var _nodeParser:CompositeCommandNodeParser;

		private var _testXML:XML = <composite-command kind="parallel" fail-on-fault="true"><object id="object1"/><object id="object2"/><object id="object3"/></composite-command>;


		public function CompositeCommandNodeParserTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			_nodeParser = new CompositeCommandNodeParser();
		}

		public function testParse():void {
			var result:IObjectDefinition = _nodeParser.parse(_testXML, new XMLObjectDefinitionsParser());
			assertEquals("org.springextensions.actionscript.core.command.CompositeCommand", result.className);
			assertEquals(0, result.constructorArguments.length);
			assertEquals(3, result.methodInvocations.length);
			assertEquals("object1",RuntimeObjectReference(MethodInvocation(result.methodInvocations[0]).arguments[0]).objectName);
			assertEquals("object2",RuntimeObjectReference(MethodInvocation(result.methodInvocations[1]).arguments[0]).objectName);
			assertEquals("object3",RuntimeObjectReference(MethodInvocation(result.methodInvocations[2]).arguments[0]).objectName);
		}

	}
}