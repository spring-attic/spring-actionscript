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
package integration.context {
	import integration.testtypes.AllAwareInterfaces;

	import org.as3commons.lang.ClassUtils;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.springextensions.actionscript.context.impl.DefaultApplicationContext;
	import org.springextensions.actionscript.ioc.config.property.impl.Properties;
	import org.springextensions.actionscript.ioc.factory.process.impl.factory.ObjectDefinitionFactoryPostProcessor;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.ObjectDefinitionScope;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class DefaultApplicationIntegrationTest {

		private var _applicationContext:DefaultApplicationContext;

		/**
		 * Creates a new <code>DefaultApplicationIntegrationTest</code> instance.
		 */
		public function DefaultApplicationIntegrationTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_applicationContext = new DefaultApplicationContext();
		}

		[Test]
		public function testAbstractClassMerging():void {
			var parentDefinition:ObjectDefinition = new ObjectDefinition();
			parentDefinition.isAbstract = true;
			parentDefinition.initMethod = "init";
			parentDefinition.scope = ObjectDefinitionScope.PROTOTYPE;
			var childDefinition:IObjectDefinition = new ObjectDefinition();
			childDefinition.parentName = "parentDef";
			_applicationContext.objectDefinitionRegistry.registerObjectDefinition("parentDef", parentDefinition);
			_applicationContext.objectDefinitionRegistry.registerObjectDefinition("childDef", childDefinition);
			_applicationContext.load();
			childDefinition = _applicationContext.objectDefinitionRegistry.getObjectDefinition("childDef") as ObjectDefinition;
			assertEquals("init", childDefinition.initMethod);
		}

		[Test]
		public function testExternalPropertyResolving():void {
			var definition:IObjectDefinition = new ObjectDefinition();
			definition.initMethod = "${init}";
			definition.scope = ObjectDefinitionScope.PROTOTYPE;
			_applicationContext.objectDefinitionRegistry.registerObjectDefinition("test", definition);
			_applicationContext.propertiesProvider = new Properties();
			_applicationContext.propertiesProvider.setProperty("init", "testMethod");
			_applicationContext.load();
			definition = _applicationContext.objectDefinitionRegistry.getObjectDefinition("test");
			assertEquals("testMethod", definition.initMethod);
		}

		[Test]
		public function testAwareInterfaceInjections():void {
			var awares:AllAwareInterfaces = new AllAwareInterfaces();
			_applicationContext.load();
			_applicationContext.wire(awares);
			assertStrictlyEquals(_applicationContext, awares.objectFactory);
			assertStrictlyEquals(_applicationContext.applicationDomain, awares.applicationDomain);
			assertStrictlyEquals(_applicationContext.objectDefinitionRegistry, awares.objectDefinitionRegistry);
			assertStrictlyEquals(_applicationContext.eventBus, awares.eventBus);
			assertStrictlyEquals(_applicationContext, awares.applicationContext);
		}
	}
}
