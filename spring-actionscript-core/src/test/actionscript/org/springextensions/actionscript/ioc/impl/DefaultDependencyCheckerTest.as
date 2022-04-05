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
package org.springextensions.actionscript.ioc.impl {
	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.verify;
	
	import org.as3commons.reflect.Type;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;
	import org.springextensions.actionscript.ioc.IDependencyChecker;
	import org.springextensions.actionscript.ioc.ILazyDependencyManager;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.impl.DefaultObjectFactory;
	import org.springextensions.actionscript.ioc.objectdefinition.DependencyCheckMode;
	import org.springextensions.actionscript.ioc.objectdefinition.IBaseObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ArgumentDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinition;
	import org.springextensions.actionscript.test.testtypes.Person;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class DefaultDependencyCheckerTest {

		private var _checker:DefaultDependencyChecker;

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();
		[Mock]
		public var factory:IObjectFactory;
		[Mock]
		public var lazyDependencyManager:ILazyDependencyManager;
		[Mock]
		public var definition:IObjectDefinition;
		[Mock]
		public var property:PropertyDefinition;

		/**
		 * Creates a new <code>DefaultDependencyCheckerTest</code> instance.
		 */
		public function DefaultDependencyCheckerTest() {
			super();
		}

		[Before]
		public function setUp():void {
			factory = nice(IObjectFactory);
			_checker = new DefaultDependencyChecker(factory);
		}

		[Test]
		public function testCheckDependenciesSatisfied():void {
			definition = nice(IObjectDefinition);
			property = nice(PropertyDefinition);
			var ror:RuntimeObjectReference = new RuntimeObjectReference("anArray");
			var properties:Vector.<PropertyDefinition> = new <PropertyDefinition>[property];
			mock(definition).getter("properties").returns(properties);
			mock(property).getter("isLazy").returns(false);
			mock(property).getter("isSimple").returns(false);
			mock(property).getter("isStatic").returns(false);
			mock(property).getter("qName").returns(new QName("", "anArray"));

			var instance:Person = new Person();
			instance.anArray = [];

			var result:LazyDependencyCheckResult = _checker.checkDependenciesSatisfied(definition, instance, "test", Type.currentApplicationDomain);
			assertStrictlyEquals(result, LazyDependencyCheckResult.SATISFIED);
			verify(definition);
			verify(property);
		}

		[Test]
		public function testCheckDependenciesSatisfiedWhenNoPropertiesOnDefinition():void {
			definition = nice(IObjectDefinition);
			property = nice(PropertyDefinition);
			mock(definition).getter("properties").returns(null);

			var instance:Person = new Person();

			var result:LazyDependencyCheckResult = _checker.checkDependenciesSatisfied(definition, instance, "test", Type.currentApplicationDomain);
			assertStrictlyEquals(result, LazyDependencyCheckResult.SATISFIED);
			verify(definition);
		}

		[Test]
		public function testCheckDependenciesUnsatisfied():void {
			definition = nice(IObjectDefinition);
			property = nice(PropertyDefinition);
			var ror:RuntimeObjectReference = new RuntimeObjectReference("anArray");
			var properties:Vector.<PropertyDefinition> = new <PropertyDefinition>[property];
			mock(definition).getter("properties").returns(properties);
			mock(definition).getter("dependencyCheck").returns(DependencyCheckMode.NONE);
			mock(property).getter("isLazy").returns(false);
			mock(property).getter("isSimple").returns(false);
			mock(property).getter("isStatic").returns(false);
			mock(property).getter("qName").returns(new QName("", "anArray"));

			var instance:Person = new Person();

			var result:LazyDependencyCheckResult = _checker.checkDependenciesSatisfied(definition, instance, "test", Type.currentApplicationDomain, false);
			assertStrictlyEquals(result, LazyDependencyCheckResult.UNSATISFIED);
			verify(definition);
			verify(property);
		}

		[Test(expects="org.springextensions.actionscript.ioc.error.UnsatisfiedDependencyError")]
		public function testCheckDependenciesUnsatisfiedWithError():void {
			definition = nice(IObjectDefinition);
			property = nice(PropertyDefinition);
			var ror:RuntimeObjectReference = new RuntimeObjectReference("anArray");
			var properties:Vector.<PropertyDefinition> = new <PropertyDefinition>[property];
			mock(definition).getter("properties").returns(properties);
			mock(definition).getter("dependencyCheck").returns(DependencyCheckMode.NONE);
			mock(property).getter("isLazy").returns(false);
			mock(property).getter("isSimple").returns(false);
			mock(property).getter("isStatic").returns(false);
			mock(property).getter("qName").returns(new QName("", "anArray"));

			var instance:Person = new Person();

			var result:LazyDependencyCheckResult = _checker.checkDependenciesSatisfied(definition, instance, "test", Type.currentApplicationDomain, true);
		}

		[Test]
		public function testCheckDependenciesUnsatisfiedButLazy():void {
			var instance:Person = new Person();
			definition = nice(IObjectDefinition);
			property = nice(PropertyDefinition);
			lazyDependencyManager = nice(ILazyDependencyManager);
			mock(lazyDependencyManager).method("registerLazyInjection").args("test", property, instance);
			_checker.lazyDependencyManager = lazyDependencyManager;
			var argDef:ArgumentDefinition = ArgumentDefinition.newInstance(new RuntimeObjectReference("anArray"));
			var properties:Vector.<PropertyDefinition> = new <PropertyDefinition>[property];
			mock(definition).getter("properties").returns(properties);
			mock(property).getter("isLazy").returns(true);
			mock(property).getter("isSimple").returns(false);
			mock(property).getter("isStatic").returns(false);
			mock(property).getter("valueDefinition").returns(argDef);
			mock(property).getter("qName").returns(new QName("", "anArray"));

			var result:LazyDependencyCheckResult = _checker.checkDependenciesSatisfied(definition, instance, "test", Type.currentApplicationDomain, false);
			assertStrictlyEquals(result, LazyDependencyCheckResult.UNSATISFIED_LAZY);
			verify(definition);
			verify(property);
			verify(lazyDependencyManager);
		}
	}
}
