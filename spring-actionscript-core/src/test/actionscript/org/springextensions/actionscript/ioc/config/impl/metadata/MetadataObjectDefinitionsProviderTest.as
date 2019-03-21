/*
 * Copyright 2007-2010 the original author or authors.
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
	import flash.system.ApplicationDomain;
	
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.stub;
	
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.StringUtils;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.autowire.AutowireMode;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.config.impl.metadata.util.MetadataConfigUtils;
	import org.springextensions.actionscript.ioc.objectdefinition.DependencyCheckMode;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.ObjectDefinitionScope;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.MethodInvocation;
	import org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponent;
	import org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentInOtherPackage;
	import org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithAutowired;
	import org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithConstructor;
	import org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithDependencyCheck;
	import org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithDependsOn;
	import org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithDestroyMethod;
	import org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithMethodInvocations;
	import org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithPrimaryLazyInitAndFactoryMethod;
	import org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithPropertiesWithExplicitValues;
	import org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithPropertiesWithPlaceholders;
	import org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithPropertiesWithRefs;
	import org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithSkips;
	import org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedLazyInitPrototypeComponent;
	import org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedNamedComponent;
	import org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedNamedComponent2;
	import org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedScopedComponent;
	import org.springextensions.actionscript.test.testtypes.metadatascan.ComponentWithConstructorArguments;
	import org.springextensions.actionscript.test.testtypes.metadatascan.ComponentWithConstructorArgumentsTypedToInterface;

	/**
	 *
	 */
	public class MetadataObjectDefinitionsProviderTest {

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var applicationContext:IApplicationContext;

		AnnotatedComponent;
		AnnotatedComponentWithConstructor;
		AnnotatedComponentWithMethodInvocations;
		ComponentWithConstructorArguments;
		AnnotatedComponentWithPropertiesWithExplicitValues;
		AnnotatedComponentWithPropertiesWithPlaceholders;
		AnnotatedComponentWithPropertiesWithRefs;
		AnnotatedLazyInitPrototypeComponent;
		AnnotatedNamedComponent;
		AnnotatedNamedComponent2;
		AnnotatedScopedComponent;
		AnnotatedComponentInOtherPackage;
		AnnotatedComponentWithAutowired;
		AnnotatedComponentWithDependencyCheck;
		AnnotatedComponentWithDependsOn;
		AnnotatedComponentWithDestroyMethod;
		AnnotatedComponentWithPrimaryLazyInitAndFactoryMethod;
		AnnotatedComponentWithSkips;

		private var _provider:MetadataObjectDefinitionsProvider;

		public function MetadataObjectDefinitionsProviderTest(methodName:String=null) {
			super();
		}

		[Before]
		public function setUp():void {
			applicationContext = nice(IApplicationContext);
			stub(applicationContext).getter("applicationDomain").returns(ApplicationDomain.currentDomain);
			_provider = new MetadataObjectDefinitionsProvider();
			_provider.applicationContext = applicationContext;
		}

		[Test]
		public function testAnnotatedComponent():void {
			_provider.scanClassNames(["org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponent"]);
			assertEquals(1, _provider.internalRegistry.numObjectDefinitions);
			var names:Vector.<String> = _provider.internalRegistry.objectDefinitionNames;
			assertTrue(StringUtils.startsWith(String(names[0]), MetadataConfigUtils.SCANNED_COMPONENT_NAME_PREFIX));
		}

		[Test]
		public function testAnnotatedNamedComponent():void {
			_provider.scanClassNames(["org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedNamedComponent"]);
			assertEquals(1, _provider.internalRegistry.numObjectDefinitions);
			var names:Vector.<String> = _provider.internalRegistry.objectDefinitionNames;
			assertEquals("annotatedNamedComponent", String(names[0]));
		}

		[Test]
		public function testAnnotatedNamedComponentWithExplicitIDKey():void {
			_provider.scanClassNames(["org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedNamedComponent2"]);
			assertEquals(1, _provider.internalRegistry.numObjectDefinitions);
			var names:Vector.<String> = _provider.internalRegistry.objectDefinitionNames;
			assertEquals("annotatedNamedComponent2", String(names[0]));
		}

		[Test]
		public function testAnnotatedScopedComponent():void {
			_provider.scanClassNames(["org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedScopedComponent"]);
			assertEquals(1, _provider.internalRegistry.numObjectDefinitions);
			var names:Vector.<String> = _provider.internalRegistry.objectDefinitionNames;
			var objDef:IObjectDefinition = _provider.internalRegistry.getObjectDefinition(names[0]);
			assertStrictlyEquals(objDef.scope, ObjectDefinitionScope.PROTOTYPE);
		}

		[Test]
		public function testAnnotatedComponentWithInitMethod():void {
			_provider.scanClassNames(["org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentInOtherPackage"]);
			assertEquals(1, _provider.internalRegistry.numObjectDefinitions);
			var names:Vector.<String> = _provider.internalRegistry.objectDefinitionNames;
			var objDef:IObjectDefinition = _provider.internalRegistry.getObjectDefinition(names[0]);
			assertEquals(objDef.initMethod, "init");
		}

		[Test]
		public function testAnnotatedComponentWithDependencyCheck():void {
			_provider.scanClassNames(["org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithDependencyCheck"]);
			assertEquals(1, _provider.internalRegistry.numObjectDefinitions);
			var names:Vector.<String> = _provider.internalRegistry.objectDefinitionNames;
			var objDef:IObjectDefinition = _provider.internalRegistry.getObjectDefinition(names[0]);
			assertStrictlyEquals(objDef.dependencyCheck, DependencyCheckMode.SIMPLE);
		}

		[Test]
		public function testAnnotatedComponentWithAutowired():void {
			_provider.scanClassNames(["org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithAutowired"]);
			assertEquals(1, _provider.internalRegistry.numObjectDefinitions);
			var names:Vector.<String> = _provider.internalRegistry.objectDefinitionNames;
			var objDef:IObjectDefinition = _provider.internalRegistry.getObjectDefinition(names[0]);
			assertStrictlyEquals(objDef.autoWireMode, AutowireMode.BYNAME);
		}

		[Test]
		public function testAnnotatedComponentWithPrimaryLazyInitAndFactoryMethod():void {
			_provider.scanClassNames(["org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithPrimaryLazyInitAndFactoryMethod"]);
			assertEquals(1, _provider.internalRegistry.numObjectDefinitions);
			var names:Vector.<String> = _provider.internalRegistry.objectDefinitionNames;
			var objDef:IObjectDefinition = _provider.internalRegistry.getObjectDefinition(names[0]);
			assertTrue(objDef.primary);
			assertTrue(objDef.isLazyInit);
			assertEquals("createNew", objDef.factoryMethod);
			assertEquals("factoryName", objDef.factoryObjectName);
		}

		[Test]
		public function testAnnotatedComponentWithDestroyMethod():void {
			_provider.scanClassNames(["org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithDestroyMethod"]);
			assertEquals(1, _provider.internalRegistry.numObjectDefinitions);
			var names:Vector.<String> = _provider.internalRegistry.objectDefinitionNames;
			var objDef:IObjectDefinition = _provider.internalRegistry.getObjectDefinition(names[0]);
			assertEquals("dispose", objDef.destroyMethod);
		}

		[Test]
		public function testAnnotatedComponentWithSkips():void {
			_provider.scanClassNames(["org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithSkips"]);
			assertEquals(1, _provider.internalRegistry.numObjectDefinitions);
			var names:Vector.<String> = _provider.internalRegistry.objectDefinitionNames;
			var objDef:IObjectDefinition = _provider.internalRegistry.getObjectDefinition(names[0]);
			assertTrue(objDef.skipMetadata);
			assertTrue(objDef.skipPostProcessors);
		}

		[Test]
		public function testAnnotatedComponentWithDependsOn():void {
			_provider.scanClassNames(["org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithDependsOn"]);
			assertEquals(1, _provider.internalRegistry.numObjectDefinitions);
			var names:Vector.<String> = _provider.internalRegistry.objectDefinitionNames;
			var objDef:IObjectDefinition = _provider.internalRegistry.getObjectDefinition(names[0]);
			assertEquals(2, objDef.dependsOn.length);
			assertEquals("objectName1", objDef.dependsOn[0]);
			assertEquals("objectName2", objDef.dependsOn[1]);
		}

		[Test]
		public function testAnnotatedComponentWithExplicitProperties():void {
			_provider.scanClassNames(["org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithPropertiesWithExplicitValues"]);
			assertEquals(1, _provider.internalRegistry.numObjectDefinitions);
			var names:Vector.<String> = _provider.internalRegistry.objectDefinitionNames;
			var objDef:IObjectDefinition = _provider.internalRegistry.getObjectDefinition(names[0]);
			assertEquals("ThisValue", objDef.getPropertyDefinitionByName("someProperty").valueDefinition.value);
			assertEquals(10, objDef.getPropertyDefinitionByName("someOtherProperty").valueDefinition.value);
		}

		[Test]
		public function testAnnotatedComponentWithRefProperties():void {
			_provider.scanClassNames(["org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithPropertiesWithRefs"]);
			assertEquals(1, _provider.internalRegistry.numObjectDefinitions);
			var names:Vector.<String> = _provider.internalRegistry.objectDefinitionNames;
			var objDef:IObjectDefinition = _provider.internalRegistry.getObjectDefinition(names[0]);
			assertNotNull(objDef.getPropertyDefinitionByName("someProperty").valueDefinition.ref);
			assertNotNull(objDef.getPropertyDefinitionByName("someOtherProperty").valueDefinition.ref);
			var rf:RuntimeObjectReference = objDef.getPropertyDefinitionByName("someProperty").valueDefinition.ref;
			assertEquals("objectName1", rf.objectName);
			rf = objDef.getPropertyDefinitionByName("someOtherProperty").valueDefinition.ref;
			assertEquals("objectName2", rf.objectName);
		}

		[Test]
		public function testAnnotatedComponentWithMethodInvocations():void {
			_provider.scanClassNames(["org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithMethodInvocations"]);
			assertEquals(1, _provider.internalRegistry.numObjectDefinitions);
			var names:Vector.<String> = _provider.internalRegistry.objectDefinitionNames;
			var objDef:IObjectDefinition = _provider.internalRegistry.getObjectDefinition(names[0]);
			assertEquals(2, objDef.methodInvocations.length);

			var mi:MethodInvocation = objDef.getMethodInvocationByName("someFunction");
			assertNotNull(mi);

			if (mi != null) {
				assertEquals("someFunction", mi.methodName);
				assertEquals(2, mi.arguments.length);
				assertNotNull(mi.arguments[0].ref);
				assertTrue(mi.arguments[1].value is Object);
				assertEquals("objectName1", mi.arguments[0].ref.objectName);
				assertEquals(10, mi.arguments[1].value);
			}

			mi = objDef.getMethodInvocationByName("someOtherFunction");
			assertNotNull(mi);

			if (mi != null) {
				assertEquals("someOtherFunction", mi.methodName);
				assertEquals(1, mi.arguments.length);
				assertNotNull(mi.arguments[0].ref);
				assertEquals("objectName2", mi.arguments[0].ref.objectName);
			}
		}

		[Test]
		public function testAnnotatedComponentWithConstructor():void {
			_provider.scanClassNames(["org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponentWithConstructor"]);
			assertEquals(1, _provider.internalRegistry.numObjectDefinitions);
			var names:Vector.<String> = _provider.internalRegistry.objectDefinitionNames;
			var objDef:IObjectDefinition = _provider.internalRegistry.getObjectDefinition(names[0]);
			assertEquals(1, objDef.constructorArguments.length);
			assertNotNull(objDef.constructorArguments[0].ref);
			assertEquals("objectName1", objDef.constructorArguments[0].ref.objectName);
		}

		[Test]
		public function testScan_shouldResolveConstructorArgumentsViaReflection():void {
			_provider.scanClassNames(["org.springextensions.actionscript.test.testtypes.metadatascan.ComponentWithConstructorArguments"]);

			var registry:IObjectDefinitionRegistry = _provider.internalRegistry;

			assertEquals(3, registry.numObjectDefinitions);

			var names:Vector.<String> = registry.objectDefinitionNames;
			var objectDefinitions:Vector.<IObjectDefinition> = registry.getObjectDefinitionsForType(ComponentWithConstructorArguments);

			assertEquals(1, objectDefinitions.length);

			var objectDefinition:IObjectDefinition = objectDefinitions[0];

			assertNotNull(objectDefinition.constructorArguments);
			assertEquals(2, objectDefinition.constructorArguments.length);
			assertNotNull(objectDefinition.constructorArguments[0].ref);
			assertNotNull(objectDefinition.constructorArguments[1].ref);

			var objectRef1:RuntimeObjectReference = objectDefinition.constructorArguments[0].ref;
			var constructorArg1Definition:IObjectDefinition = registry.getObjectDefinition(objectRef1.objectName);
			assertEquals(ClassUtils.getFullyQualifiedName(AnnotatedComponent, true), constructorArg1Definition.className);

			var objectRef2:RuntimeObjectReference = objectDefinition.constructorArguments[1].ref;
			var constructorArg2Definition:IObjectDefinition = registry.getObjectDefinition(objectRef2.objectName);
			assertEquals(ClassUtils.getFullyQualifiedName(AnnotatedNamedComponent, true), constructorArg2Definition.className);
		}

		/*public function testScan_shouldResolvePropertiesViaReflection():void {
			_provider.scanClassNames(["org.springextensions.actionscript.test.testtypes.metadatascan.ComponentWithProperties");

			var appContext:IApplicationContext = _scanner.applicationContext;

			assertEquals(3, appContext.numObjectDefinitions);

			var names:Vector.<String> = appContext.objectDefinitionNames;
			var objectDefinitions:Array = appContext.getObjectDefinitionsOfType(ComponentWithProperties);

			assertEquals(1, objectDefinitions.length);

			var objectDefinition:IObjectDefinition = objectDefinitions[0];

			assertNotNull(objectDefinition.properties);
			assertEquals(2, ObjectUtils.getNumProperties(objectDefinition.properties));

			var propertyNames:Array = ObjectUtils.getKeys(objectDefinition.properties);
			assertTrue(objectDefinition.properties[propertyNames[0]] is RuntimeObjectReference);
			assertTrue(objectDefinition.properties[propertyNames[1]] is RuntimeObjectReference);

			var objectRef1:RuntimeObjectReference = objectDefinition.properties["property1"];
			var property1Definition:IObjectDefinition = appContext.getObjectDefinition(objectRef1.objectName);
			assertEquals(ClassUtils.getFullyQualifiedName(AnnotatedComponent, true), property1Definition.className);

			var objectRef2:RuntimeObjectReference = objectDefinition.properties["property2"];
			var constructorArg2Definition:IObjectDefinition = appContext.getObjectDefinition(objectRef2.objectName);
			assertEquals(ClassUtils.getFullyQualifiedName(AnnotatedNamedComponent, true), constructorArg2Definition.className);
		}*/

		// --------------------------------------------------------------------
		//
		// Tests - scanClassNames
		//
		// --------------------------------------------------------------------

		[Test]
		public function testScan_shouldResolveConstructorArgumentsTypedToInterfaceViaReflection():void {
			var classNames:Array = [];
			classNames.push("org.springextensions.actionscript.test.testtypes.metadatascan.ComponentWithConstructorArgumentsTypedToInterface");
			classNames.push("org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedComponent");
			classNames.push("org.springextensions.actionscript.test.testtypes.metadatascan.AnnotatedNamedComponent");

			_provider.scanClassNames(classNames);
			var registry:IObjectDefinitionRegistry = _provider.internalRegistry;


			assertEquals(3, registry.numObjectDefinitions);

			var names:Vector.<String> = registry.objectDefinitionNames;
			var objectDefinitions:Vector.<IObjectDefinition> = registry.getObjectDefinitionsForType(ComponentWithConstructorArgumentsTypedToInterface);

			assertNotNull(objectDefinitions);
			assertEquals(1, objectDefinitions.length);

			var objectDefinition:IObjectDefinition = objectDefinitions[0];

			assertNotNull(objectDefinition.constructorArguments);
			assertEquals(2, objectDefinition.constructorArguments.length);
			assertNotNull(objectDefinition.constructorArguments[0].ref);
			assertNotNull(objectDefinition.constructorArguments[1].ref);

			var objectRef1:RuntimeObjectReference = objectDefinition.constructorArguments[0].ref;
			var constructorArg1Definition:IObjectDefinition = registry.getObjectDefinition(objectRef1.objectName);
			assertEquals(ClassUtils.getFullyQualifiedName(AnnotatedComponent, true), constructorArg1Definition.className);

			var objectRef2:RuntimeObjectReference = objectDefinition.constructorArguments[1].ref;
			var constructorArg2Definition:IObjectDefinition = registry.getObjectDefinition(objectRef2.objectName);
			assertEquals(ClassUtils.getFullyQualifiedName(AnnotatedNamedComponent, true), constructorArg2Definition.className);
		}

	}
}
