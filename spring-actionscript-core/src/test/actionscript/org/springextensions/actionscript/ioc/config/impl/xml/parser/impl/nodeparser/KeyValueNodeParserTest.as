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

	import flash.system.ApplicationDomain;

	import flexunit.framework.TestCase;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.springextensions.actionscript.context.impl.ApplicationContext;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.XMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.factory.impl.DefaultObjectFactory;

	/**
	 * @author Christophe Herreman
	 */
	public class KeyValueNodeParserTest {

		public function KeyValueNodeParserTest() {
			super();
		}

		[Test]
		/**
		 * When we parse a node that has no child/value (e.g. <value/>), we return an empty string.
		 */
		public function testParse_shouldReturnEmptyStringIfNodeHasNoChild():void {
			var parser:KeyValueNodeParser = new KeyValueNodeParser(new XMLObjectDefinitionsParser(new ApplicationContext(null, new DefaultObjectFactory())), ApplicationDomain.currentDomain);
			var result:String = String(parser.parse(<value/>));
			assertNotNull(result);
			assertEquals("", result);
		}

	}
}
