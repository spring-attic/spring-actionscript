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
package org.springextensions.actionscript.ioc.config.impl.mxml.custom.stage {
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.springextensions.actionscript.ioc.config.impl.mxml.component.MXMLObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class StageAutowireProcessorTest {

		private var _processor:StageAutowireProcessor;

		/**
		 * Creates a new <code>StageAutowireProcessorTest</code> instance.
		 */
		public function StageAutowireProcessorTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_processor = new StageAutowireProcessor();
		}

		[Test]
		public function testExecuteWithSelectorName():void {
			var definitions:Object = {};
			_processor.id = "test";
			_processor.objectSelector = "selector";
			_processor.execute(null, definitions);
			assertNotNull(definitions["test"]);
			var definition:IObjectDefinition = definitions["test"];
			assertEquals("org.springextensions.actionscript.stage.DefaultFlexAutowiringStageProcessor", definition.className);
			assertEquals("selector", definition.customConfiguration);
		}

		[Test]
		public function testExecuteWithSelectorMXMLDefinition():void {
			var definitions:Object = {};
			_processor.id = "test";
			var mxmlDef:MXMLObjectDefinition = new MXMLObjectDefinition();
			mxmlDef.id = "selector";
			_processor.objectSelector = mxmlDef;
			_processor.execute(null, definitions);
			assertNotNull(definitions["test"]);
			var definition:IObjectDefinition = definitions["test"];
			assertEquals("org.springextensions.actionscript.stage.DefaultFlexAutowiringStageProcessor", definition.className);
			assertEquals("selector", definition.customConfiguration);
		}
	}
}
