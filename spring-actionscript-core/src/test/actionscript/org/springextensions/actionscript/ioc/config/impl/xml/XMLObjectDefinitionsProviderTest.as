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
package org.springextensions.actionscript.ioc.config.impl.xml {

	import mockolate.ingredients.Invocation;
	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.stub;
	import mockolate.verify;

	import org.as3commons.async.operation.IOperation;
	import org.as3commons.async.operation.event.OperationEvent;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.core.anything;
	import org.springextensions.actionscript.ioc.config.ITextFilesLoader;
	import org.springextensions.actionscript.ioc.config.impl.AsyncObjectDefinitionProviderResultOperation;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
import org.springextensions.actionscript.test.testtypes.EmbeddedContexts;

public class XMLObjectDefinitionsProviderTest {

		private var _xmlObjectDefinitionProvider:XMLObjectDefinitionsProvider;

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var parser:IXMLObjectDefinitionsParser;
		[Mock]
		public var loader:ITextFilesLoader;
		[Mock]
		public var operation:IOperation;

		public function XMLObjectDefinitionsProviderTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_xmlObjectDefinitionProvider = new XMLObjectDefinitionsProvider();
			parser = nice(IXMLObjectDefinitionsParser);
			_xmlObjectDefinitionProvider.parser = parser;
		}

		[Test]
		public function testLoadWithExplicitXML():void {
			var xml:XML = new XML("<objects/>");
			_xmlObjectDefinitionProvider.addLocation(xml);
			mock(parser).method("parse").args(anything(), null).once();
			var result:IOperation = _xmlObjectDefinitionProvider.createDefinitions();
			verify(parser);
			assertNull(result);
		}

		[Test]
		public function testLoadWithEmbeddedXML():void {
			_xmlObjectDefinitionProvider.addLocation(EmbeddedContexts.embeddedEmptyContext);
			mock(parser).method("parse").args(anything(), null).once();
			var result:IOperation = _xmlObjectDefinitionProvider.createDefinitions();
			verify(parser);
			assertNull(result);
		}

		[Test]
		public function testLoadWithExternalXML():void {
			var _func:Function;
			var uri:String = "config.xml";
			var vec:Vector.<String> = new Vector.<String>();
			vec.push("<objects/>");
			loader = nice(ITextFilesLoader);
			_xmlObjectDefinitionProvider.textFilesLoader = loader;
			mock(loader).asEventDispatcher();
			mock(loader).method("addURI").args(uri).once();
			mock(loader).getter("total").returns(1);
			mock(loader).method("addCompleteListener").callsWithInvocation(function(invoc:Invocation):void {
				_func = invoc.arguments[0];
			});

			_xmlObjectDefinitionProvider.addLocation(uri);
			mock(parser).method("parse").args(anything(), null).once();
			var result:IOperation = _xmlObjectDefinitionProvider.createDefinitions();
			operation = nice(IOperation);
			mock(operation).getter("result").returns(vec);
			var operationEvent:OperationEvent = new OperationEvent("complete", operation);
			stub(operation).getter("result").returns(vec);
			_func(operationEvent);
			verify(loader);
			verify(parser);
			assertNotNull(result);
			assertTrue(result is AsyncObjectDefinitionProviderResultOperation);
		}

	}
}
