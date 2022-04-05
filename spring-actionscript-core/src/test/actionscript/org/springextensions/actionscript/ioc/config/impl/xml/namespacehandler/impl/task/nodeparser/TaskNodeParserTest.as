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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser {

	import org.as3commons.lang.ClassUtils;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.springextensions.actionscript.context.impl.DefaultApplicationContext;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.XMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.MethodInvocation;

	public class TaskNodeParserTest {

		private var _testParser:TaskNodeParser;

		private var _emptyTaskXML:XML = <task/>;

		private var _taskWithOneAndXML:XML = <task><and command="testCommand"/></task>;

		private var _taskWithOneForXML:XML = <task><for id="testFor"><count-provider count="10" id="testcount"><ref>testcount</ref></count-provider></for></task>;

		private var _taskWithOneIfXML:XML = <task><if id="testIf"><condition><ref>conditionRef</ref></condition></if></task>;

		private var _taskWithOneWhileXML:XML = <task><while id="testWhile"><condition><ref>conditionRef</ref></condition></while></task>;

		private var _taskWithAndLoadURLNodeXML:XML = <task><and><load-url id="testLoadUrl" url="test.swf"/></and></task>;

		public function TaskNodeParserTest() {
			super();
			_testParser = new TaskNodeParser();
		}

		[Test]
		public function testParseWithEmptyTask():void {
			var result:IObjectDefinition = _testParser.parse(_emptyTaskXML, new XMLObjectDefinitionsParser(new DefaultApplicationContext()));
			assertEquals("org.as3commons.async.task.impl.Task", result.className);
		}

		[Test]
		public function testParseWithOneAndElement():void {
			var result:IObjectDefinition = _testParser.parse(_taskWithOneAndXML, new XMLObjectDefinitionsParser(new DefaultApplicationContext()));
			assertEquals("org.as3commons.async.task.impl.Task", result.className);
			assertEquals(1, result.methodInvocations.length);
			assertEquals(TaskNodeParser.andMethod, result.methodInvocations[0].methodName);
			assertEquals(1, result.methodInvocations[0].arguments.length);
			assertNotNull(result.methodInvocations[0].arguments[0].ref);
			var rf:RuntimeObjectReference = result.methodInvocations[0].arguments[0].ref;
			assertEquals("testCommand", rf.objectName);
		}

		[Test]
		public function testParseWithOneForElement():void {
			var result:IObjectDefinition = _testParser.parse(_taskWithOneForXML, new XMLObjectDefinitionsParser(new DefaultApplicationContext()));
			assertEquals("org.as3commons.async.task.impl.Task", result.className);
			assertEquals(1, result.methodInvocations.length);
			assertEquals(TaskNodeParser.forMethod, MethodInvocation(result.methodInvocations[0]).methodName);
			assertEquals(3, result.methodInvocations[0].arguments.length);
			assertNotNull(result.methodInvocations[0].arguments[2].ref);
			var rf:RuntimeObjectReference = result.methodInvocations[0].arguments[2].ref;
			assertEquals("testFor", rf.objectName);
		}

		[Test]
		public function testParseWithOneIfElement():void {
			var result:IObjectDefinition = _testParser.parse(_taskWithOneIfXML, new XMLObjectDefinitionsParser(new DefaultApplicationContext()));
			assertEquals("org.as3commons.async.task.impl.Task", result.className);
			assertEquals(1, result.methodInvocations.length);
			assertEquals(TaskNodeParser.ifMethod, result.methodInvocations[0].methodName);
			assertEquals(2, result.methodInvocations[0].arguments.length);
			assertNotNull(result.methodInvocations[0].arguments[1].ref);
			var rf:RuntimeObjectReference = result.methodInvocations[0].arguments[1].ref;
			assertEquals("testIf", rf.objectName);
		}

		[Test]
		public function testParseWithOneWhileElement():void {
			var result:IObjectDefinition = _testParser.parse(_taskWithOneWhileXML, new XMLObjectDefinitionsParser(new DefaultApplicationContext()));
			assertEquals("org.as3commons.async.task.impl.Task", result.className);
			assertEquals(1, result.methodInvocations.length);
			assertEquals(TaskNodeParser.whileMethod, result.methodInvocations[0].methodName);
			assertEquals(2, result.methodInvocations[0].arguments.length);
			assertNotNull(result.methodInvocations[0].arguments[1].ref);
			var rf:RuntimeObjectReference = result.methodInvocations[0].arguments[1].ref;
			assertEquals("testWhile", rf.objectName);
		}

		[Test]
		public function testParseWithAndLoadURLElement():void {
			var result:IObjectDefinition = _testParser.parse(_taskWithAndLoadURLNodeXML, new XMLObjectDefinitionsParser(new DefaultApplicationContext()));
			assertEquals("org.as3commons.async.task.impl.Task", result.className);
			assertEquals(1, result.methodInvocations.length);
			assertEquals(TaskNodeParser.andMethod, result.methodInvocations[0].methodName);
			assertEquals(1, result.methodInvocations[0].arguments.length);
			assertNotNull(result.methodInvocations[0].arguments[0].ref);
			var rf:RuntimeObjectReference = result.methodInvocations[0].arguments[0].ref;
			assertEquals("testLoadUrl", rf.objectName);
		}
	}
}
