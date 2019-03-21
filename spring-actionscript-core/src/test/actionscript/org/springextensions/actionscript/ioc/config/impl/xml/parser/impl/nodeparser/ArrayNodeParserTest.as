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

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.impl.ApplicationContext;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.XMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.factory.impl.DefaultObjectFactory;

	/**
	 * @author Christophe Herreman
	 */
	public class ArrayNodeParserTest {

		public function ArrayNodeParserTest() {
			super();
		}

		[Test]
		public function testParse():void {
			var context:IApplicationContext = new ApplicationContext(null, new DefaultObjectFactory());
			var parser:ArrayNodeParser = new ArrayNodeParser(new XMLObjectDefinitionsParser(context));
			var result:Array = parser.parse(<array>
					<value>a</value>
					<value>1</value>
					<value>true</value>
				</array>) as Array;
			assertNotNull(result);
			assertEquals(3, result.length);
			assertEquals("a", result[0]);
			assertEquals(1, result[1]);
			assertEquals(true, result[2]);
		}

	}
}
