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
	import flexunit.framework.TestCase;

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
	import org.springextensions.actionscript.context.metadata.testclasses.AnnotatedLazyInitPrototypeComponent;
	import org.springextensions.actionscript.context.metadata.testclasses.AnnotatedNamedComponent;
	import org.springextensions.actionscript.context.metadata.testclasses.AnnotatedNamedComponent2;
	import org.springextensions.actionscript.context.metadata.testclasses.AnnotatedScopedComponent;
	import org.springextensions.actionscript.context.metadata.testclasses.ComponentWithConstructorArgumentsTypedToInterface;
	import org.springextensions.actionscript.context.metadata.testclasses.ComponentWithConstructorArguments;
	
	import org.springextensions.actionscript.context.support.XMLApplicationContext;
	import org.springextensions.actionscript.test.SASTestCase;

	public class ClassScannerObjectFactoryPostProcessorTest extends SASTestCase {

		private static var _classes:Array = [//
						AnnotatedComponentWithPropertiesWithPlaceholders,//
						AnnotatedComponentWithConstructor,//
						AnnotatedComponentWithMethodInvocations,//
						AnnotatedComponentWithPropertiesWithRefs,//
						AnnotatedComponentWithPropertiesWithExplicitValues,//
						AnnotatedComponentInOtherPackage,//
						AnnotatedComponent,//
						AnnotatedLazyInitPrototypeComponent,//
						AnnotatedNamedComponent,//
						AnnotatedNamedComponent2,//
						AnnotatedScopedComponent,//
						AnnotatedComponentWithDependencyCheck,//
						AnnotatedComponentWithAutowired,//
						AnnotatedComponentWithPrimaryLazyInitAndFactoryMethod,//
						AnnotatedComponentWithDestroyMethod,//
						AnnotatedComponentWithSkips,//
						AnnotatedComponentWithDependsOn,//
						ComponentWithConstructorArgumentsTypedToInterface,
						ComponentWithConstructorArguments
						];

		public function ClassScannerObjectFactoryPostProcessorTest(methodName:String = null) {
			super(methodName);
		}

		public function testPostProcessObjectFactory():void {
			var factory:ClassScannerObjectFactoryPostProcessor = new ClassScannerObjectFactoryPostProcessor();
			var context:XMLApplicationContext = new XMLApplicationContext();
			context.properties.setProperty("replaceMe1", "test1");
			context.properties.setProperty("replaceMe2", "test2");
			factory.postProcessObjectFactory(context);
			assertEquals(_classes.length, context.numObjectDefinitions);
			context.dispose();
		}
	}
}