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
package org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser {

	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.impl.DefaultApplicationContext;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.XMLObjectDefinitionsParser;

	/**
	 * @author Christophe Herreman
	 */
	public class ObjectNodeParserTest {

		private var _context:IApplicationContext;
		private var _parser:ObjectNodeParser;

		public function ObjectNodeParserTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_context = new DefaultApplicationContext();
			_parser = new ObjectNodeParser(new XMLObjectDefinitionsParser(_context));
		}

		[Test]
		public function testParse():void {
			var result:Object = _parser.parse(<object id='test'>
					<property name="key1" value="value1"/>
					<property name="key2" value="35"/>
					<property name="key3" value="false"/>
					<property name="key4">
						<array>
							<value>12</value>
							<value>test</value>
						</array>
					</property>
				</object>);

			assertNotNull(result);
			assertTrue(result is RuntimeObjectReference);
		}

		[Test]
		public function testParseWithParentRefInConstructorArg():void {
			var result:Object = _parser.parse(<object id='test'>
					<property name="parentObject">
						<object parent="aParentNode" id='test2'/>
					</property>
				</object>);

			assertNotNull(result);
			assertTrue(result is RuntimeObjectReference);
		}

	}
}
