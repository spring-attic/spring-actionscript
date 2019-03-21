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
package org.springextensions.actionscript.ioc.config.property.impl {
	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.verify;

	import org.flexunit.asserts.assertEquals;
	import org.springextensions.actionscript.ioc.config.property.IPropertiesProvider;
	import org.springextensions.actionscript.ioc.factory.process.impl.factory.PropertyPlaceholderConfigurerFactoryPostProcessor;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class PropertyPlaceholderResolverTest {

		private var _testPropertyPlaceHolder:String = "${propertyName}";
		private var _testPropertyPlaceHolder2:String = "${propertyName}_${propertyName2}";
		private var _resolver:PropertyPlaceholderResolver;
		private var _regexp:RegExp = PropertyPlaceholderConfigurerFactoryPostProcessor.PROPERTY_REGEXP;

		[Rule]
		public var mockolate:MockolateRule = new MockolateRule();

		[Mock]
		public var properties:IPropertiesProvider;

		/**
		 * Creates a new <code>PropertyPlaceholderResolverTest</code> instance.
		 */
		public function PropertyPlaceholderResolverTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_resolver = new PropertyPlaceholderResolver();
		}

		[Test]
		public function testGetPropertyName():void {
			var result:String = PropertyPlaceholderResolver.getPropertyName(_testPropertyPlaceHolder);
			assertEquals("propertyName", result);
		}

		[Test]
		public function testReplacePropertyPlaceholder():void {
			properties = nice(IPropertiesProvider);
			mock(properties).method("getProperty").args("propertyName").returns("propertyValue").once();
			var value:String = _resolver.replacePropertyPlaceholder(_testPropertyPlaceHolder, _regexp, properties);
			verify(properties);
			assertEquals("propertyValue", value);
		}

		[Test]
		public function testResolvePropertyPlaceholders():void {
			properties = nice(IPropertiesProvider);
			mock(properties).method("getProperty").args("propertyName").returns("propertyValue").once();
			mock(properties).method("getProperty").args("propertyName2").returns("propertyValue2").once();
			var value:String = _resolver.resolvePropertyPlaceholders(_testPropertyPlaceHolder2, _regexp, properties);
			verify(properties);
			assertEquals("propertyValue_propertyValue2", value);
		}
	}
}
