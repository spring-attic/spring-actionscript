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
package org.springextensions.actionscript.ioc.config.impl.mxml {
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.stub;
	import mockolate.verify;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.core.anything;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.factory.IInstanceCache;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinition;
	import org.springextensions.actionscript.test.testtypes.MXMLConfig;
	import org.springextensions.actionscript.test.testtypes.MXMLConfig2;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class MXMLObjectDefinitionsProviderTest {

		private var _provider:MXMLObjectDefinitionsProvider;

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var applicationContext:IApplicationContext;
		[Mock]
		public var cache:IInstanceCache;

		public function MXMLObjectDefinitionsProviderTest() {
			super();
		}

		[Before]
		public function setUp():void {
			applicationContext = nice(IApplicationContext);
			cache = nice(IInstanceCache);
			stub(applicationContext).getter("applicationDomain").returns(ApplicationDomain.currentDomain);
			stub(applicationContext).getter("cache").returns(cache);
			_provider = new MXMLObjectDefinitionsProvider();
			_provider.applicationContext = applicationContext;
		}

		[Test]
		public function testAddConfiguration():void {
			assertNull(_provider.configurations);
			_provider.addConfiguration(MXMLConfig);
			assertEquals(1, _provider.configurations.length);
			assertStrictlyEquals(MXMLConfig, _provider.configurations[0]);
		}

		[Test]
		public function testAddSameConfigurationTwice():void {
			assertNull(_provider.configurations);
			_provider.addConfiguration(MXMLConfig);
			assertEquals(1, _provider.configurations.length);
			assertStrictlyEquals(MXMLConfig, _provider.configurations[0]);
			_provider.addConfiguration(MXMLConfig);
			assertEquals(1, _provider.configurations.length);
			assertStrictlyEquals(MXMLConfig, _provider.configurations[0]);
		}

		[Test]
		public function testAddTwoConfigurations():void {
			assertNull(_provider.configurations);
			_provider.addConfiguration(MXMLConfig);
			assertEquals(1, _provider.configurations.length);
			assertStrictlyEquals(MXMLConfig, _provider.configurations[0]);
			_provider.addConfiguration(Event);
			assertEquals(2, _provider.configurations.length);
			assertStrictlyEquals(Event, _provider.configurations[1]);
		}

		[Test]
		public function testCreateDefinitions():void {
			mock(cache).method("putInstance").args("remoteObj", anything()).once();
			mock(cache).method("putInstance").args("collection", anything()).once();
			_provider.addConfiguration(MXMLConfig);
			_provider.createDefinitions();
			assertNotNull(_provider.objectDefinitions);
			assertNotNull(_provider.objectDefinitions['myObject']);
			verify(cache);
		}

		[Test]
		public function testCreateDefinitionsWithTwoConfigs():void {
			mock(cache).method("putInstance").args("remoteObj", anything()).once();
			mock(cache).method("putInstance").args("collection", anything()).once();
			_provider.addConfiguration(MXMLConfig);
			_provider.addConfiguration(MXMLConfig2);
			_provider.createDefinitions();
			assertNotNull(_provider.objectDefinitions);
			assertNotNull(_provider.objectDefinitions['myObject']);
			assertNotNull(_provider.objectDefinitions['myObject2']);
			var definition:IObjectDefinition = _provider.objectDefinitions['myObject2'];
			assertNotNull(definition.properties);
			assertEquals(1, definition.properties.length);
			var propDef:PropertyDefinition = definition.properties[0];
			assertEquals("test", propDef.name);
			assertNotNull(propDef.valueDefinition.ref);
			assertEquals("remoteObj", propDef.valueDefinition.ref.objectName);
			verify(cache);
		}

		[Test]
		public function testResolveRuntimeObjectReferenceByValue():void {
			mock(cache).method("putInstance").args("remoteObj", anything()).once();
			mock(cache).method("putInstance").args("collection", anything()).once();
			_provider.addConfiguration(MXMLConfig);
			_provider.createDefinitions();
			assertNotNull(_provider.objectDefinitions);
			assertNotNull(_provider.objectDefinitions['myObject']);
			assertNotNull(_provider.objectDefinitions['myObject2']);
			var definition:IObjectDefinition = _provider.objectDefinitions['myObject2'];
			var propDef:PropertyDefinition = definition.getPropertyDefinitionByName("testProperty");
			assertNotNull(propDef.valueDefinition.ref);
			verify(cache);

		}
	}
}
