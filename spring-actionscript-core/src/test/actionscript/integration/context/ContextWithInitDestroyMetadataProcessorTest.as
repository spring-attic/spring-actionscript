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
package integration.context {
	import flexunit.framework.TestCase;

	import org.as3commons.bytecode.abc.ClassInfo;
	import org.as3commons.lang.ClassUtils;
	import org.springextensions.actionscript.context.support.AbstractApplicationContext;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.ObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.config.RequiredMetadataProcessor;
	import org.springextensions.actionscript.ioc.factory.metadata.InitDestroyMetadataProcessor;

	import org.springextensions.actionscript.metadata.MetadataProcessorObjectPostProcessor;

	import testclasses.initdestroy.ClassWithOnePostConstructAndOnePreDestroyMetadata;
	import testclasses.initdestroy.ClassWithOnePostConstructMetadata;

	public class ContextWithInitDestroyMetadataProcessorTest extends TestCase {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function ContextWithInitDestroyMetadataProcessorTest() {
		}

		// --------------------------------------------------------------------
		//
		// Tests
		//
		// --------------------------------------------------------------------

		public function testInitDestroyMetadataProcessor():void {
			var context:AbstractApplicationContext = new AbstractApplicationContext();
			context.addObjectPostProcessor(new InitDestroyMetadataProcessor());

			var className:String = ClassUtils.getFullyQualifiedName(ClassWithOnePostConstructAndOnePreDestroyMetadata);
			context.objectDefinitions["object"] = new ObjectDefinition(className);

			context.load();

			var object:ClassWithOnePostConstructAndOnePreDestroyMetadata = context.getObject("object");

			assertEquals(1, object.numInitMethodsExecuted);
			assertEquals(0, object.numDestroyMethodsExecuted);

			context.dispose();

			assertEquals(1, object.numInitMethodsExecuted);
			assertEquals(1, object.numDestroyMethodsExecuted);
		}

	}
}