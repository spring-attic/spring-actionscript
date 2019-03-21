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
package org.springextensions.actionscript.ioc.config.impl.metadata {
	import avmplus.getQualifiedClassName;
	
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.config.impl.metadata.util.MetadataConfigUtils;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.DefaultObjectDefinitionRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.MethodInvocation;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinition;
	import org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithConstructor;
	import org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithMethodInvocations;
	import org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithPropertiesWithRefs;
	import org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedNamedComponent2;
	import org.springextensions.actionscript.test.testtypes.metadatascan.TestConfigurationClass;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ConfigurationClassScannerTest {

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var applicationContext:IApplicationContext;

		public var _objectDefinitionRegistry:IObjectDefinitionRegistry;

		private var _configurationClassScanner:ConfigurationClassScanner;

		/**
		 * Creates a new <code>ConfigurationClassScannerTest</code> instance.
		 */
		public function ConfigurationClassScannerTest() {
			super();
		}

		[Before]
		public function setUp():void {
			applicationContext = nice(IApplicationContext);
			_configurationClassScanner = new ConfigurationClassScanner(new MetadataConfigUtils(), applicationContext);
			_objectDefinitionRegistry = new DefaultObjectDefinitionRegistry();
		}

		[Test]
		public function testScan():void {
			_configurationClassScanner.scan(getQualifiedClassName(TestConfigurationClass), _objectDefinitionRegistry, {});

			assertEquals(4, _objectDefinitionRegistry.objectDefinitionNames.length);
			assertTrue(_objectDefinitionRegistry.containsObjectDefinition("component1"));
			assertTrue(_objectDefinitionRegistry.containsObjectDefinition("component2"));
			assertTrue(_objectDefinitionRegistry.containsObjectDefinition("component3"));
			assertTrue(_objectDefinitionRegistry.containsObjectDefinition("annotatedNamedComponent2"));

			var definition:IObjectDefinition = _objectDefinitionRegistry.getObjectDefinition("component1");
			var propDef:PropertyDefinition = definition.getPropertyDefinitionByName("someProperty");
			assertNotNull(propDef);
			assertNotNull(propDef.valueDefinition.ref);
			assertEquals("objectName1", propDef.valueDefinition.ref.objectName);

			propDef = definition.getPropertyDefinitionByName("someOtherProperty");
			assertNotNull(propDef);
			assertNotNull(propDef.valueDefinition.ref);
			assertEquals("objectName2", propDef.valueDefinition.ref.objectName);
			assertStrictlyEquals(definition.clazz, AnnotatedComponentWithPropertiesWithRefs);

			definition = _objectDefinitionRegistry.getObjectDefinition("component2");
			assertEquals(2, definition.methodInvocations.length);
			var methDef:MethodInvocation = definition.getMethodInvocationByName("someFunction");
			assertNotNull(methDef);
			assertEquals(2, methDef.arguments.length);
			assertNotNull(methDef.arguments[0].ref);
			assertEquals("objectName1", methDef.arguments[0].ref.objectName);
			assertStrictlyEquals(definition.clazz, AnnotatedComponentWithMethodInvocations);

			definition = _objectDefinitionRegistry.getObjectDefinition("component3");
			assertEquals(1, definition.constructorArguments.length);
			assertNotNull(definition.constructorArguments[0].ref);
			assertEquals("objectName1", definition.constructorArguments[0].ref.objectName);
			assertStrictlyEquals(definition.clazz, AnnotatedComponentWithConstructor);

			definition = _objectDefinitionRegistry.getObjectDefinition("annotatedNamedComponent2");
			assertStrictlyEquals(definition.clazz, AnnotatedNamedComponent2);
		}
	}
}
