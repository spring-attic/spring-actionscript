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
package org.springextensions.actionscript.context.impl.mxml {
	import flash.events.Event;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.stub;
	import mockolate.verify;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.core.anything;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.config.IConfigurationPackage;
	import org.springextensions.actionscript.ioc.config.IObjectDefinitionsProvider;
	import org.springextensions.actionscript.ioc.config.impl.mxml.MXMLObjectDefinitionsProvider;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class MXMLApplicationContextTest {

		private var _applicationContext:MXMLApplicationContext;

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var configurationPackage:IConfigurationPackage;
		[Mock]
		public var definitionProvider:MXMLObjectDefinitionsProvider;

		public function MXMLApplicationContextTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_applicationContext = new MXMLApplicationContext();
		}

		[Test]
		public function testConstruction():void {
			assertEquals(1, _applicationContext.definitionProviders.length);
			assertTrue(_applicationContext.definitionProviders[0] is MXMLObjectDefinitionsProvider);
		}

	/*[Test]
	public function testInitializeContextWithoutConfigurationPackage():void {
		mock(innerApplicationContext).method("addDefinitionProvider").args(anything()).once();
		mock(innerApplicationContext).method("load").never();
		assertFalse(_applicationContext.contextInitialized);
		_applicationContext.initializeContext();
		assertStrictlyEquals(innerApplicationContext, _applicationContext.applicationContext);
		assertNotNull(_applicationContext.applicationContext);
		assertTrue(_applicationContext.contextInitialized);
		verify(innerApplicationContext);
	}

	[Test]
	public function testInitializeContextWitConfigurationPackage():void {
		configurationPackage = nice(IConfigurationPackage);
		mock(innerApplicationContext).method("addDefinitionProvider").args(anything()).once();
		mock(innerApplicationContext).method("configure").args(configurationPackage).once();
		mock(innerApplicationContext).method("load").never();

		_applicationContext.configurationPackage = configurationPackage;

		assertStrictlyEquals(configurationPackage, _applicationContext.configurationPackage);

		assertFalse(_applicationContext.contextInitialized);
		_applicationContext.initializeContext();

		assertNotNull(_applicationContext.applicationContext);
		assertTrue(_applicationContext.contextInitialized);

		assertNull(_applicationContext.configurationPackage);

		verify(innerApplicationContext);
	}

	[Test]
	public function testInitializeContextWitAutoLoadSetToTrue():void {
		var cls:Class = Event;
		_applicationContext.configurations = [cls];
		configurationPackage = nice(IConfigurationPackage);
		definitionProvider = nice(MXMLObjectDefinitionsProvider);
		var providers:Vector.<IObjectDefinitionsProvider> = new Vector.<IObjectDefinitionsProvider>();
		providers[providers.length] = definitionProvider;
		mock(definitionProvider).method("addConfiguration").args(cls).once();
		mock(innerApplicationContext).method("addDefinitionProvider").args(anything()).once();
		mock(innerApplicationContext).method("configure").args(configurationPackage).once();
		mock(innerApplicationContext).method("load").once();
		mock(innerApplicationContext).method("addEventListener").args(Event.COMPLETE, anything()).once();
		mock(innerApplicationContext).getter("definitionProviders").returns(providers).once();

		_applicationContext.autoLoad = true;
		_applicationContext.configurationPackage = configurationPackage;

		assertStrictlyEquals(configurationPackage, _applicationContext.configurationPackage);

		assertFalse(_applicationContext.contextInitialized);
		_applicationContext.initializeContext();

		assertNotNull(_applicationContext.applicationContext);
		assertTrue(_applicationContext.contextInitialized);

		assertNull(_applicationContext.configurationPackage);

		verify(definitionProvider);
		verify(innerApplicationContext);
	}*/
	}
}
