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
package org.springextensions.actionscript.ioc.factory.process.impl.factory {
	import mockolate.ingredients.floxy.FloxyInvocation;
	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.stub;
	import mockolate.verify;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.hamcrest.core.anything;
	import org.hamcrest.object.instanceOf;
	import org.springextensions.actionscript.ioc.objectdefinition.ICustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ArgumentDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.MethodInvocation;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ObjectDefinitonFactoryPostProcessorTest {

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var registry:IObjectDefinitionRegistry;
		[Mock]
		public var objectDefinition:IObjectDefinition;
		[Mock]
		public var methodInvocation:MethodInvocation;
		[Mock]
		public var propertyDefinition:PropertyDefinition;
		[Mock]
		public var customConfiguration:ICustomConfigurator;

		public var parentDefinition:IObjectDefinition;

		private var _processor:ObjectDefinitionFactoryPostProcessor;

		public function ObjectDefinitonFactoryPostProcessorTest() {
			super();
		}

		[Before]
		public function setUp():void {
			registry = nice(IObjectDefinitionRegistry);
			objectDefinition = nice(IObjectDefinition);
			parentDefinition = nice(IObjectDefinition);
			stub(objectDefinition).getter("parent").returns(parentDefinition);
			_processor = new ObjectDefinitionFactoryPostProcessor(1);
		}

		[Test]
		public function testCopyConstructorArgumentsWithAllNullArgs():void {
			mock(objectDefinition).getter("constructorArguments").returns(null);
			mock(parentDefinition).getter("constructorArguments").returns(null);
			mock(objectDefinition).setter("constructorArguments").never();
			_processor.copyConstructorArguments(parentDefinition, objectDefinition);
			verify(objectDefinition);
			verify(parentDefinition);
		}

		[Test]
		public function testCopyConstructorArgumentsWitAllNotnUllArgs():void {
			mock(objectDefinition).getter("constructorArguments").returns(new Vector.<ArgumentDefinition>());
			stub(parentDefinition).getter("constructorArguments").returns(new Vector.<ArgumentDefinition>());
			mock(objectDefinition).setter("constructorArguments").never();
			_processor.copyConstructorArguments(parentDefinition, objectDefinition);
			verify(objectDefinition);
		}

		[Test]
		public function testCopyConstructorArgumentsWitParentNotnUllArgs():void {
			var args:Vector.<ArgumentDefinition> = new Vector.<ArgumentDefinition>();
			var vecClass:Class = Object(args).constructor as Class;
			mock(objectDefinition).getter("constructorArguments").returns(null);
			mock(parentDefinition).getter("constructorArguments").returns(args);
			mock(objectDefinition).setter("constructorArguments").arg(instanceOf(vecClass)).once();
			_processor.copyConstructorArguments(parentDefinition, objectDefinition);
			verify(objectDefinition);
			verify(parentDefinition);
		}

		[Test]
		public function testCopyConstructorArgumentsWitBothNotnUllArgs():void {
			var args:Vector.<ArgumentDefinition> = new Vector.<ArgumentDefinition>();
			var args2:Vector.<ArgumentDefinition> = new Vector.<ArgumentDefinition>();
			mock(objectDefinition).getter("constructorArguments").returns(args2).once();
			stub(parentDefinition).getter("constructorArguments").returns(args).once();
			mock(objectDefinition).setter("constructorArguments").arg(args).never();
			_processor.copyConstructorArguments(parentDefinition, objectDefinition);
			verify(objectDefinition);
		}

		[Test]
		public function testSetParentPropertyWithBothSet():void {
			mock(objectDefinition).getter("destroyMethod").returns("myMethod").once();
			stub(parentDefinition).getter("destroyMethod").returns("myOtherMethod");
			mock(objectDefinition).setter("destroyMethod").arg(anything()).never();
			_processor.copyDefinitionProperty(parentDefinition, objectDefinition, "destroyMethod");
			verify(objectDefinition);
		}

		[Test]
		public function testSetParentPropertyWithParentSet():void {
			mock(objectDefinition).getter("destroyMethod").returns(null).once();
			mock(parentDefinition).getter("destroyMethod").returns("myOtherMethod");
			mock(objectDefinition).setter("destroyMethod").arg("myOtherMethod").once();
			_processor.copyDefinitionProperty(parentDefinition, objectDefinition, "destroyMethod");
			verify(objectDefinition);
			verify(parentDefinition);
		}

		[Test]
		public function testCopyMethodInvocation():void {
			methodInvocation = nice(MethodInvocation);
			var methodInvocation2:MethodInvocation = nice(MethodInvocation);
			mock(methodInvocation).getter("methodName").returns("methodName").once();
			mock(methodInvocation).getter("namespaceURI").returns(null).once();
			mock(methodInvocation).method("clone").returns(methodInvocation2).once();
			mock(objectDefinition).method("getMethodInvocationByName").args("methodName", null).returns(null).once();
			mock(objectDefinition).method("addMethodInvocation").args(methodInvocation2).once();
			_processor.copyMethodInvocation(objectDefinition, methodInvocation);
			verify(methodInvocation);
			verify(objectDefinition);
		}

		[Test]
		public function testCopyMethodInvocationWhenDestinationHasInvocationAlready():void {
			methodInvocation = nice(MethodInvocation);
			var methodInvocation2:MethodInvocation = nice(MethodInvocation);
			mock(methodInvocation).getter("methodName").returns("methodName").once();
			mock(methodInvocation).getter("namespaceURI").returns(null).once();
			mock(objectDefinition).method("getMethodInvocationByName").args("methodName", null).returns(methodInvocation2).once();
			mock(objectDefinition).method("addMethodInvocation").args(anything()).never();
			_processor.copyMethodInvocation(objectDefinition, methodInvocation);
			verify(methodInvocation);
			verify(objectDefinition);
		}

		[Test]
		public function testCopyProperty():void {
			propertyDefinition = nice(PropertyDefinition);
			var propertyDefinition2:PropertyDefinition = nice(PropertyDefinition);
			mock(propertyDefinition).getter("name").returns("propertyName").once();
			mock(propertyDefinition).getter("namespaceURI").returns(null).once();
			mock(propertyDefinition).method("clone").returns(propertyDefinition2).once();
			mock(objectDefinition).method("getPropertyDefinitionByName").args("propertyName", null).returns(null).once();
			mock(objectDefinition).method("addPropertyDefinition").args(propertyDefinition2).once();
			_processor.copyProperty(objectDefinition, propertyDefinition);
			verify(propertyDefinition);
			verify(objectDefinition);
		}

		[Test]
		public function testCopyPropertyWhenDestinationHasPropertyAlready():void {
			propertyDefinition = nice(PropertyDefinition);
			var propertyDefinition2:PropertyDefinition = nice(PropertyDefinition);
			mock(propertyDefinition).getter("name").returns("propertyName").once();
			mock(propertyDefinition).getter("namespaceURI").returns(null).once();
			mock(propertyDefinition).method("clone").returns(propertyDefinition2).never();
			mock(objectDefinition).method("getPropertyDefinitionByName").args("propertyName", null).returns(propertyDefinition2).once();
			mock(objectDefinition).method("addPropertyDefinition").args(propertyDefinition2).never();
			_processor.copyProperty(objectDefinition, propertyDefinition);
			verify(propertyDefinition);
			verify(objectDefinition);
		}

		[Test]
		public function testResolveParentDefinitions():void {
			var parentDefinition:IObjectDefinition = nice(IObjectDefinition);
			registry = nice(IObjectDefinitionRegistry);
			var names:Vector.<String> = new Vector.<String>();
			names[names.length] = "objectName";
			mock(registry).getter("objectDefinitionNames").returns(names).once();
			mock(registry).method("getObjectDefinition").args("objectName").returns(objectDefinition).once();
			mock(objectDefinition).getter("parentName").returns("parentName").atLeast(2);
			mock(registry).method("getObjectDefinition").args("parentName").returns(parentDefinition).once();
			mock(objectDefinition).setter("parent").arg(parentDefinition).once();
			_processor.resolveParentDefinitions(registry);
			verify(registry);
			verify(objectDefinition);
			verify(parentDefinition);
		}

		[Test]
		public function testMergeCustomConfiguratorsForDefinitionsWithoutCustomCOnfigurators():void {
			var sourceDefinition:IObjectDefinition = nice(IObjectDefinition);
			mock(sourceDefinition).getter("customConfiguration").returns(null).once();

			_processor.mergeCustomConfigurators(sourceDefinition, null);

			verify(sourceDefinition);
		}

		[Test]
		public function testMergeCustomConfiguratorsForDefinitionsWithSingleSourceDefinitionCustomConfigAndNoDestinationCunstomConfig():void {
			var sourceDefinition:IObjectDefinition = nice(IObjectDefinition);
			var destinationDefinition:IObjectDefinition = nice(IObjectDefinition);
			customConfiguration = nice(ICustomConfigurator);

			mock(sourceDefinition).getter("customConfiguration").returns(customConfiguration);
			mock(destinationDefinition).getter("customConfiguration").returns(null).once();
			mock(destinationDefinition).setter("customConfiguration").arg(customConfiguration).once();

			_processor.mergeCustomConfigurators(sourceDefinition, destinationDefinition);

			verify(sourceDefinition);
			verify(destinationDefinition);
		}

		[Test]
		public function testMergeCustomConfiguratorsForDefinitionsWithSingleSourceDefinitionCustomConfigAndSingleDestinationCunstomConfig():void {
			var sourceDefinition:IObjectDefinition = nice(IObjectDefinition);
			var destinationDefinition:IObjectDefinition = nice(IObjectDefinition);
			customConfiguration = nice(ICustomConfigurator);
			var customConfiguration2:ICustomConfigurator = nice(ICustomConfigurator);

			mock(sourceDefinition).getter("customConfiguration").returns(customConfiguration);
			mock(destinationDefinition).getter("customConfiguration").returns(customConfiguration2);
			mock(destinationDefinition).setter("customConfiguration").callsWithInvocation(function(invocation:FloxyInvocation):void {
				var vector:Vector.<Object> = invocation.arguments[0];
				assertEquals(2, vector.length);
				assertStrictlyEquals(customConfiguration2, vector[0]);
				assertStrictlyEquals(customConfiguration, vector[1]);
			});

			_processor.mergeCustomConfigurators(sourceDefinition, destinationDefinition);

			verify(sourceDefinition);
			verify(destinationDefinition);
		}

		[Test]
		public function testMergeCustomConfiguratorsForDefinitionsWithSingleSourceDefinitionWithoutCustomConfigAndSingleDestinationCunstomConfig():void {
			var sourceDefinition:IObjectDefinition = nice(IObjectDefinition);
			var destinationDefinition:IObjectDefinition = nice(IObjectDefinition);
			customConfiguration = nice(ICustomConfigurator);

			mock(sourceDefinition).getter("customConfiguration").returns(null).once();
			mock(destinationDefinition).getter("customConfiguration").returns(customConfiguration).never();

			_processor.mergeCustomConfigurators(sourceDefinition, destinationDefinition);

			verify(sourceDefinition);
			verify(destinationDefinition);
		}
	}
}
