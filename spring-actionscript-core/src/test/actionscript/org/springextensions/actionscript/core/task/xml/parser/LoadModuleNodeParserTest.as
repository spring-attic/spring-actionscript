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

	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.config.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	import org.springextensions.actionscript.module.LoadModuleOperation;

	public class LoadModuleNodeParserTest extends TestCase {

		private var _loadModuleNodeParser:LoadModuleNodeParser;

		private var _testLoadModuleXML:XML = <load-module url="module.swf" application-domain="appDomainName" security-domain="secDomainName"/>;

		public function LoadModuleNodeParserTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			_loadModuleNodeParser = new LoadModuleNodeParser();
		}

		public function testParse():void {
			var result:IObjectDefinition = _loadModuleNodeParser.parse(_testLoadModuleXML, new XMLObjectDefinitionsParser());
			assertNotNull(result);
			assertEquals("org.springextensions.actionscript.core.command.GenericOperationCommand", result.className);
			assertEquals(4, result.constructorArguments.length);
			assertStrictlyEquals(LoadModuleOperation, result.constructorArguments[0]);
			assertEquals("module.swf", result.constructorArguments[1]);
			assertEquals("appDomainName", RuntimeObjectReference(result.constructorArguments[2]).objectName);
			assertEquals("secDomainName", RuntimeObjectReference(result.constructorArguments[3]).objectName);
		}
	}
}