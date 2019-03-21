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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task {
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;


	public class TaskElementsPreprocessorTest {

		public var _ns:Namespace = new Namespace("t", "http://www.springactionscript.org/schema/task");

		private var _testProcessor:TaskElementsPreprocessor;

		private var _testTaskWithIDXML:XML = <task id="testid"/>;

		private var _testTaskWithoutIDXML:XML = <task/>;

		private var _testNextXML:XML = <next command="commandRef"/>;

		private var _testAndWithObjectIdXML:XML = <and><object id="testid"/></and>;

		private var _testAndWithOperationChildXML:XML = <and><load-url/></and>;

		private var _testAndWithOperationChildWithIdXML:XML = <and><load-url id="testid"/></and>;

		private var _testAndWithoutObjectIdXML:XML = <and><object/></and>;

		private var _testNextWithObjectIdXML:XML = <next><object id="testid"/></next>;

		private var _testNextWithoutObjectIdXML:XML = <next><object/></next>;

		private var _testCommandXML:XML = <command ref="commandRef"/>;

		private var _testIfXML:XML = <if condition="conditionRef"/>;

		private var _testWhileXML:XML = <while condition="conditionRef"/>;

		private var _testForWithProviderXML:XML = <for count-provider="countProviderRef"/>;

		private var _testForWithCountXML:XML = <for count="10"/>;

		private var _testPauseXML:XML = <pause duration="100"/>;

		private var _testCompositeCommandXML:XML = <composite-command><object/><object/><object/></composite-command>;

		public function TaskElementsPreprocessorTest() {
			super();
			init();
		}

		protected function init():void {
			default xml namespace = _ns;
			_testTaskWithIDXML.setNamespace(_ns);
			_testTaskWithoutIDXML.setNamespace(_ns);
			_testNextXML.setNamespace(_ns);
			_testAndWithObjectIdXML.setNamespace(_ns);
			_testAndWithoutObjectIdXML.setNamespace(_ns);
			_testAndWithOperationChildXML = setNamespace(_testAndWithOperationChildXML);
			_testAndWithOperationChildWithIdXML = setNamespace(_testAndWithOperationChildWithIdXML);
			_testNextWithObjectIdXML.setNamespace(_ns);
			_testNextWithoutObjectIdXML.setNamespace(_ns);
			_testCommandXML.setNamespace(_ns);
			_testIfXML.setNamespace(_ns);
			_testWhileXML.setNamespace(_ns);
			_testForWithProviderXML.setNamespace(_ns);
			_testForWithCountXML.setNamespace(_ns);
			_testPauseXML.setNamespace(_ns);
			_testProcessor = new TaskElementsPreprocessor();
		}

		[Test]
		public function testPreprocessTaskElement():void {
			var node:XML = _testProcessor.preprocessTaskElement(_testTaskWithIDXML);
			assertEquals("testid", node.@id);

			node = _testProcessor.preprocessTaskElement(_testTaskWithoutIDXML);
			assertTrue(node.@id !== undefined);
		}

		[Test]
		public function testPreprocessAndElement():void {
			var node:XML = _testProcessor.preprocessAndOrNextElement(_testAndWithObjectIdXML);
			var id:String = node.@command;
			var id2:String = node.object.@id;
			var testXML:XML = setNamespace(<and command={id}></and>);
			testXML.appendChild(<object id={id2}/>);
			assertEquals(testXML, node);
			assertEquals(id, id2);

			node = _testProcessor.preprocessAndOrNextElement(_testAndWithoutObjectIdXML);
			id = node.@command;
			id2 = node.object.@id;
			testXML = setNamespace(<and command={id}></and>);
			testXML.appendChild(<object id={id2}/>);
			assertEquals(testXML, node);
			assertEquals(id, id2);

		}

		[Test]
		public function testPreprocessAndElementWithOperationChild():void {
			var node:XML = _testProcessor.preprocessAndOrNextElement(_testAndWithOperationChildXML);
			var id:String = node.@command;
			var id2:String = node.descendants("load-url").@id;
			var testXML:XML = <and command={id}></and>;
			testXML.appendChild(<load-url id={id2}/>);
			setNamespace(testXML);
			assertEquals(testXML, node);
			assertEquals(id, id2);

			node = _testProcessor.preprocessAndOrNextElement(_testAndWithOperationChildWithIdXML);
			id = node.@command;
			id2 = node.descendants("load-url").@id;
			testXML = <and command={id}></and>;
			testXML.appendChild(<load-url id={id2}/>);
			setNamespace(testXML);
			assertEquals(testXML, node);
			assertEquals(id, id2);
		}

		[Test]
		public function testPreprocessNextElement():void {
			var node:XML = _testProcessor.preprocessAndOrNextElement(_testNextWithObjectIdXML);
			var id:String = node.@command;
			var id2:String = node.object.@id;
			var testXML:XML = setNamespace(<next command={id}></next>);
			testXML.appendChild(<object id={id2}/>);
			assertEquals(testXML, node);
			assertEquals(id, id2);

			node = _testProcessor.preprocessAndOrNextElement(_testNextWithoutObjectIdXML);
			id = node.@command;
			id2 = node.object.@id;
			testXML = setNamespace(<next command={id}></next>);
			testXML.appendChild(<object id={id2}/>);
			assertEquals(testXML, node);
			assertEquals(id, id2);

		}

		[Test]
		public function testPreprocessIfElement():void {
			var node:XML = _testProcessor.preprocessIfElement(_testIfXML);
			var id:String = node.@id;
			assertEquals(setNamespace(<if id={id}><condition><ref>conditionRef</ref></condition></if>), node);
		}

		[Test]
		public function testPreprocessForElement():void {
			var node:XML = _testProcessor.preprocessForElement(_testForWithProviderXML);
			var id:String = node.@id;
			assertEquals(setNamespace(<for id={id}><count-provider><ref>countProviderRef</ref></count-provider></for>), node);

			node = _testProcessor.preprocessForElement(_testForWithCountXML);
			id = node.@id;
			var id2:String = node.descendants("count-provider")[0].@id;
			assertEquals(setNamespace(<for id={id}><count-provider count="10" id={id2}><ref>{id2}</ref></count-provider></for>), node);
		}

		[Test]
		public function testPreprocessWhileElement():void {
			var node:XML = _testProcessor.preprocessWhileElement(_testWhileXML);
			var id:String = node.@id;
			assertEquals(setNamespace(<while id={id}><condition><ref>conditionRef</ref></condition></while>), node);
		}

		[Test]
		public function testPreprocesPauseElement():void {
			var node:XML = _testProcessor.preprocessPauseElement(_testPauseXML);
			var id:String = node.descendants(TaskNamespaceHandler.PAUSECOMMAND_ELEMENT).@id;
			assertEquals(setNamespace(<pause><pause-command duration="100" id={id}/></pause>), node);
		}

		[Test]
		public function testPreprocesCompositeCommandElement():void {
			var node:XML = _testProcessor.preprocessCompositeCommandElement(_testCompositeCommandXML);
			for each (var subnode:XML in node.children()) {
				assertEquals(1, subnode.@id.length());
			}
		}

		private function setNamespace(node:XML):XML {
			for each (var sn:XML in node.descendants()) {
				sn.setNamespace(_ns);
			}
			node.setNamespace(_ns);
			return node;
		}

	}
}
