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
package org.springextensions.actionscript.context.metadata {
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.ObjectUtils;
	import org.as3commons.lang.StringUtils;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.metadata.othertestclasses.AnnotatedComponentInOtherPackage;
	import org.springextensions.actionscript.context.metadata.othertestclasses.AnnotatedComponentWithAutowired;
	import org.springextensions.actionscript.context.metadata.othertestclasses.AnnotatedComponentWithDependencyCheck;
	import org.springextensions.actionscript.context.metadata.othertestclasses.AnnotatedComponentWithDependsOn;
	import org.springextensions.actionscript.context.metadata.othertestclasses.AnnotatedComponentWithDestroyMethod;
	import org.springextensions.actionscript.context.metadata.othertestclasses.AnnotatedComponentWithPrimaryLazyInitAndFactoryMethod;
	import org.springextensions.actionscript.context.metadata.othertestclasses.AnnotatedComponentWithSkips;
	import org.springextensions.actionscript.context.metadata.testclasses.AnnotatedComponent;
	import org.springextensions.actionscript.context.metadata.testclasses.AnnotatedComponentWithConstructor;
	import org.springextensions.actionscript.context.metadata.testclasses.AnnotatedComponentWithMethodInvocations;
	import org.springextensions.actionscript.context.metadata.testclasses.AnnotatedComponentWithPropertiesWithExplicitValues;
	import org.springextensions.actionscript.context.metadata.testclasses.AnnotatedComponentWithPropertiesWithPlaceholders;
	import org.springextensions.actionscript.context.metadata.testclasses.AnnotatedComponentWithPropertiesWithRefs;
	import org.springextensions.actionscript.context.metadata.testclasses.ComponentWithConstructorArguments;
	import org.springextensions.actionscript.context.metadata.testclasses.AnnotatedLazyInitPrototypeComponent;
	import org.springextensions.actionscript.context.metadata.testclasses.AnnotatedNamedComponent;
	import org.springextensions.actionscript.context.metadata.testclasses.AnnotatedNamedComponent2;
	import org.springextensions.actionscript.context.metadata.testclasses.AnnotatedScopedComponent;
	import org.springextensions.actionscript.context.metadata.testclasses.ComponentWithConstructorArgumentsTypedToInterface;
	import org.springextensions.actionscript.context.metadata.testclasses.ComponentWithProperties;
	import org.springextensions.actionscript.context.metadata.testclasses.IAnnotatedComponent;
	import org.springextensions.actionscript.context.support.XMLApplicationContext;
	import org.springextensions.actionscript.ioc.AutowireMode;
	import org.springextensions.actionscript.ioc.DependencyCheckMode;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.MethodInvocation;
	import org.springextensions.actionscript.ioc.ObjectDefinitionScope;
	import org.springextensions.actionscript.ioc.factory.config.RuntimeObjectReference;
	import org.springextensions.actionscript.test.SASTestCase;

	/**
	 *
	 */
	public class ComponentClassScannerTest extends SASTestCase {

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


		private var _scanner:ComponentClassScanner;

		public function ComponentClassScannerTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			super.setUp();
			_scanner = new ComponentClassScanner();
			_scanner.applicationContext = new XMLApplicationContext();
		}

		override public function tearDown():void {
			super.tearDown();
			_scanner = null;
		}

		public function testAnnotatedComponent():void {
			_scanner.scan("org.springextensions.actionscript.context.metadata.testclasses.AnnotatedComponent");
			assertEquals(1, _scanner.applicationContext.numObjectDefinitions);
			var names:Array = _scanner.applicationContext.objectDefinitionNames;
			assertTrue(StringUtils.startsWith(String(names[0]), ComponentClassScanner.SCANNED_COMPONENT_NAME_PREFIX));
		}

		public function testAnnotatedNamedComponent():void {
			_scanner.scan("org.springextensions.actionscript.context.metadata.testclasses.AnnotatedNamedComponent");
			assertEquals(1, _scanner.applicationContext.numObjectDefinitions);
			var names:Array = _scanner.applicationContext.objectDefinitionNames;
			assertEquals("annotatedNamedComponent", String(names[0]));
		}

		public function testAnnotatedNamedComponentWithExplicitIDKey():void {
			_scanner.scan("org.springextensions.actionscript.context.metadata.testclasses.AnnotatedNamedComponent2");
			assertEquals(1, _scanner.applicationContext.numObjectDefinitions);
			var names:Array = _scanner.applicationContext.objectDefinitionNames;
			assertEquals("annotatedNamedComponent2", String(names[0]));
		}

		public function testAnnotatedScopedComponent():void {
			_scanner.scan("org.springextensions.actionscript.context.metadata.testclasses.AnnotatedScopedComponent");
			assertEquals(1, _scanner.applicationContext.numObjectDefinitions);
			var names:Array = _scanner.applicationContext.objectDefinitionNames;
			var objDef:IObjectDefinition = _scanner.applicationContext.objectDefinitions[String(names[0])];
			assertStrictlyEquals(objDef.scope, ObjectDefinitionScope.PROTOTYPE);
		}

		public function testAnnotatedComponentWithInitMethod():void {
			_scanner.scan("org.springextensions.actionscript.context.metadata.othertestclasses.AnnotatedComponentInOtherPackage");
			assertEquals(1, _scanner.applicationContext.numObjectDefinitions);
			var names:Array = _scanner.applicationContext.objectDefinitionNames;
			var objDef:IObjectDefinition = _scanner.applicationContext.objectDefinitions[String(names[0])];
			assertEquals(objDef.initMethod, "init");
		}

		public function testAnnotatedComponentWithDependencyCheck():void {
			_scanner.scan("org.springextensions.actionscript.context.metadata.othertestclasses.AnnotatedComponentWithDependencyCheck");
			assertEquals(1, _scanner.applicationContext.numObjectDefinitions);
			var names:Array = _scanner.applicationContext.objectDefinitionNames;
			var objDef:IObjectDefinition = _scanner.applicationContext.objectDefinitions[String(names[0])];
			assertStrictlyEquals(objDef.dependencyCheck, DependencyCheckMode.SIMPLE);
		}

		public function testAnnotatedComponentWithAutowired():void {
			_scanner.scan("org.springextensions.actionscript.context.metadata.othertestclasses.AnnotatedComponentWithAutowired");
			assertEquals(1, _scanner.applicationContext.numObjectDefinitions);
			var names:Array = _scanner.applicationContext.objectDefinitionNames;
			var objDef:IObjectDefinition = _scanner.applicationContext.objectDefinitions[String(names[0])];
			assertStrictlyEquals(objDef.autoWireMode, AutowireMode.BYNAME);
		}

		public function testAnnotatedComponentWithPrimaryLazyInitAndFactoryMethod():void {
			_scanner.scan("org.springextensions.actionscript.context.metadata.othertestclasses.AnnotatedComponentWithPrimaryLazyInitAndFactoryMethod");
			assertEquals(1, _scanner.applicationContext.numObjectDefinitions);
			var names:Array = _scanner.applicationContext.objectDefinitionNames;
			var objDef:IObjectDefinition = _scanner.applicationContext.objectDefinitions[String(names[0])];
			assertTrue(objDef.primary);
			assertTrue(objDef.isLazyInit);
			assertEquals("createNew", objDef.factoryMethod);
			assertEquals("factoryName", objDef.factoryObjectName);
		}

		public function testAnnotatedComponentWithDestroyMethod():void {
			_scanner.scan("org.springextensions.actionscript.context.metadata.othertestclasses.AnnotatedComponentWithDestroyMethod");
			assertEquals(1, _scanner.applicationContext.numObjectDefinitions);
			var names:Array = _scanner.applicationContext.objectDefinitionNames;
			var objDef:IObjectDefinition = _scanner.applicationContext.objectDefinitions[String(names[0])];
			assertEquals("dispose", objDef.destroyMethod);
		}

		public function testAnnotatedComponentWithSkips():void {
			_scanner.scan("org.springextensions.actionscript.context.metadata.othertestclasses.AnnotatedComponentWithSkips");
			assertEquals(1, _scanner.applicationContext.numObjectDefinitions);
			var names:Array = _scanner.applicationContext.objectDefinitionNames;
			var objDef:IObjectDefinition = _scanner.applicationContext.objectDefinitions[String(names[0])];
			assertTrue(objDef.skipMetadata);
			assertTrue(objDef.skipPostProcessors);
		}

		public function testAnnotatedComponentWithDependsOn():void {
			_scanner.scan("org.springextensions.actionscript.context.metadata.othertestclasses.AnnotatedComponentWithDependsOn");
			assertEquals(1, _scanner.applicationContext.numObjectDefinitions);
			var names:Array = _scanner.applicationContext.objectDefinitionNames;
			var objDef:IObjectDefinition = _scanner.applicationContext.objectDefinitions[String(names[0])];
			assertEquals(2, objDef.dependsOn.length);
			assertEquals("objectName1", objDef.dependsOn[0]);
			assertEquals("objectName2", objDef.dependsOn[1]);
		}

		public function testAnnotatedComponentWithExplicitProperties():void {
			_scanner.scan("org.springextensions.actionscript.context.metadata.testclasses.AnnotatedComponentWithPropertiesWithExplicitValues");
			assertEquals(1, _scanner.applicationContext.numObjectDefinitions);
			var names:Array = _scanner.applicationContext.objectDefinitionNames;
			var objDef:IObjectDefinition = _scanner.applicationContext.objectDefinitions[String(names[0])];
			assertEquals("ThisValue", objDef.properties["someProperty"]);
			assertEquals(10, objDef.properties["someOtherProperty"]);
		}

		public function testAnnotatedComponentWithRefProperties():void {
			_scanner.scan("org.springextensions.actionscript.context.metadata.testclasses.AnnotatedComponentWithPropertiesWithRefs");
			assertEquals(1, _scanner.applicationContext.numObjectDefinitions);
			var names:Array = _scanner.applicationContext.objectDefinitionNames;
			var objDef:IObjectDefinition = _scanner.applicationContext.objectDefinitions[String(names[0])];
			assertTrue(objDef.properties["someProperty"] is RuntimeObjectReference);
			assertTrue(objDef.properties["someOtherProperty"] is RuntimeObjectReference);
			var rf:RuntimeObjectReference = objDef.properties["someProperty"];
			assertEquals("objectName1", rf.objectName);
			rf = objDef.properties["someOtherProperty"];
			assertEquals("objectName2", rf.objectName);
		}

		public function testAnnotatedComponentWithMethodInvocations():void {
			_scanner.scan("org.springextensions.actionscript.context.metadata.testclasses.AnnotatedComponentWithMethodInvocations");
			assertEquals(1, _scanner.applicationContext.numObjectDefinitions);
			var names:Array = _scanner.applicationContext.objectDefinitionNames;
			var objDef:IObjectDefinition = _scanner.applicationContext.objectDefinitions[String(names[0])];
			assertEquals(2, objDef.methodInvocations.length);

			for each (var mi:MethodInvocation in objDef.methodInvocations) {
				if (mi.methodName == "someFunction") {
					break;
				}
			}

			if (mi != null) {
				assertEquals("someFunction", mi.methodName);
				assertEquals(2, mi.arguments.length);
				assertTrue(mi.arguments[0] is RuntimeObjectReference);
				assertTrue(mi.arguments[1] is Object);
				assertEquals("objectName1", RuntimeObjectReference(mi.arguments[0]).objectName);
				assertEquals(10, mi.arguments[1]);
			} else {
				fail("no method-invocation with name someFunction found");
			}

			for each (mi in objDef.methodInvocations) {
				if (mi.methodName == "someOtherFunction") {
					break;
				}
			}

			if (mi != null) {
				assertEquals("someOtherFunction", mi.methodName);
				assertEquals(1, mi.arguments.length);
				assertTrue(mi.arguments[0] is RuntimeObjectReference);
				assertEquals("objectName2", RuntimeObjectReference(mi.arguments[0]).objectName);
			} else {
				fail("no method-invocation with name someOtherFunction found");
			}

		}

		public function testAnnotatedComponentWithConstructor():void {
			_scanner.scan("org.springextensions.actionscript.context.metadata.testclasses.AnnotatedComponentWithConstructor");
			assertEquals(1, _scanner.applicationContext.numObjectDefinitions);
			var names:Array = _scanner.applicationContext.objectDefinitionNames;
			var objDef:IObjectDefinition = _scanner.applicationContext.objectDefinitions[names[0]];
			assertEquals(1, objDef.constructorArguments.length);
			assertTrue(objDef.constructorArguments[0] is RuntimeObjectReference);
			assertEquals("objectName1", RuntimeObjectReference(objDef.constructorArguments[0]).objectName);
		}

		public function testAnnotatedComponentWithPropertyPlaceHolders():void {
			_scanner.applicationContext.properties.setProperty("replaceMe1", "test1");
			_scanner.applicationContext.properties.setProperty("replaceMe2", "test2");
			_scanner.scan("org.springextensions.actionscript.context.metadata.testclasses.AnnotatedComponentWithPropertiesWithPlaceholders");
			assertEquals(1, _scanner.applicationContext.numObjectDefinitions);
			var names:Array = _scanner.applicationContext.objectDefinitionNames;
			var objDef:IObjectDefinition = _scanner.applicationContext.objectDefinitions[String(names[0])];
			assertEquals("test1", objDef.properties["someProperty"]);
			assertEquals("test2", objDef.properties["someOtherProperty"]);
		}

		// --------------------------------------------------------------------
		//
		// Tests - scan()
		//
		// --------------------------------------------------------------------

		public function testScan_shouldResolveConstructorArgumentsViaReflection():void {
			_scanner.scan("org.springextensions.actionscript.context.metadata.testclasses.ComponentWithConstructorArguments");

			var appContext:IApplicationContext = _scanner.applicationContext;

			assertEquals(3, appContext.numObjectDefinitions);

			var names:Array = appContext.objectDefinitionNames;
			var objectDefinitions:Array = appContext.getObjectDefinitionsOfType(ComponentWithConstructorArguments);

			assertEquals(1, objectDefinitions.length);

			var objectDefinition:IObjectDefinition = objectDefinitions[0];

			assertNotNull(objectDefinition.constructorArguments);
			assertEquals(2, objectDefinition.constructorArguments.length);
			assertTrue(objectDefinition.constructorArguments[0] is RuntimeObjectReference);
			assertTrue(objectDefinition.constructorArguments[1] is RuntimeObjectReference);

			var objectRef1:RuntimeObjectReference = objectDefinition.constructorArguments[0];
			var constructorArg1Definition:IObjectDefinition = appContext.getObjectDefinition(objectRef1.objectName);
			assertEquals(ClassUtils.getFullyQualifiedName(AnnotatedComponent, true), constructorArg1Definition.className);

			var objectRef2:RuntimeObjectReference = objectDefinition.constructorArguments[1];
			var constructorArg2Definition:IObjectDefinition = appContext.getObjectDefinition(objectRef2.objectName);
			assertEquals(ClassUtils.getFullyQualifiedName(AnnotatedNamedComponent, true), constructorArg2Definition.className);
		}

		/*public function testScan_shouldResolvePropertiesViaReflection():void {
			_scanner.scan("org.springextensions.actionscript.context.metadata.testclasses.ComponentWithProperties");

			var appContext:IApplicationContext = _scanner.applicationContext;

			assertEquals(3, appContext.numObjectDefinitions);

			var names:Array = appContext.objectDefinitionNames;
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

		public function testScan_shouldResolveConstructorArgumentsTypedToInterfaceViaReflection():void {
			var classNames:Array = [];
			classNames.push("org.springextensions.actionscript.context.metadata.testclasses.ComponentWithConstructorArgumentsTypedToInterface");
			classNames.push("org.springextensions.actionscript.context.metadata.testclasses.AnnotatedComponent");
			classNames.push("org.springextensions.actionscript.context.metadata.testclasses.AnnotatedNamedComponent");

			_scanner.scanClassNames(classNames);

			var appContext:IApplicationContext = _scanner.applicationContext;

			assertEquals(3, appContext.numObjectDefinitions);

			var names:Array = appContext.objectDefinitionNames;
			var objectDefinitions:Array = appContext.getObjectDefinitionsOfType(ComponentWithConstructorArgumentsTypedToInterface);

			assertEquals(1, objectDefinitions.length);

			var objectDefinition:IObjectDefinition = objectDefinitions[0];

			assertNotNull(objectDefinition.constructorArguments);
			assertEquals(2, objectDefinition.constructorArguments.length);
			assertTrue(objectDefinition.constructorArguments[0] is RuntimeObjectReference);
			assertTrue(objectDefinition.constructorArguments[1] is RuntimeObjectReference);

			var objectRef1:RuntimeObjectReference = objectDefinition.constructorArguments[0];
			var constructorArg1Definition:IObjectDefinition = appContext.getObjectDefinition(objectRef1.objectName);
			assertEquals(ClassUtils.getFullyQualifiedName(AnnotatedComponent, true), constructorArg1Definition.className);

			var objectRef2:RuntimeObjectReference = objectDefinition.constructorArguments[1];
			var constructorArg2Definition:IObjectDefinition = appContext.getObjectDefinition(objectRef2.objectName);
			assertEquals(ClassUtils.getFullyQualifiedName(AnnotatedNamedComponent, true), constructorArg2Definition.className);
		}

	}
}