/*
 * Copyright 2007-2008 the original author or authors.
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
package org.springextensions.actionscript.ioc.factory.config {

	import org.as3commons.lang.ClassUtils;
	import org.as3commons.reflect.IMetadataContainer;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.context.support.AbstractApplicationContext;
	import org.springextensions.actionscript.flexunit.FlexUnitTestCase;
	import org.springextensions.actionscript.ioc.ObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.objects.testclasses.ObjectWithRequiredProperty;

	public class RequiredMetadataObjectPostProcessorTest extends FlexUnitTestCase {

		public function RequiredMetadataObjectPostProcessorTest(methodName:String = null) {
			super(methodName);
		}

		public function testObjectWithRequiredMetadata():void {
			var ro:ObjectWithRequiredProperty = new ObjectWithRequiredProperty();
			var className:String = ClassUtils.getFullyQualifiedName(Object(ro).constructor as Class, true);
			var od:ObjectDefinition = new ObjectDefinition(className);
			od.properties['required'] = true;

			var objectFactory:IObjectFactory = new AbstractApplicationContext();
			objectFactory.objectDefinitions['requiredTest'] = od;

			var pp:RequiredMetadataProcessor = new RequiredMetadataProcessor();
			pp.objectFactory = objectFactory;

			var containers:Array = Type.forInstance(ro).getMetadataContainers("Required");
			try {
				pp.process(ro, containers[0] as IMetadataContainer, "Required", "requiredTest");
				assertTrue(true);
			} catch (e:Error) {
				fail("ObjectWithRequiredProperty should be valid");
			}
		}

		public function testObjectWithMissingRequiredDefinitionProperties():void {
			var ro:ObjectWithRequiredProperty = new ObjectWithRequiredProperty();
			var className:String = ClassUtils.getFullyQualifiedName(Object(ro).constructor as Class, true);
			var od:ObjectDefinition = new ObjectDefinition(className);
			od.properties['notRequired'] = true;

			var objectFactory:IObjectFactory = new AbstractApplicationContext();
			objectFactory.objectDefinitions['requiredTest'] = od;

			var pp:RequiredMetadataProcessor = new RequiredMetadataProcessor();
			pp.objectFactory = objectFactory;

			var containers:Array = Type.forInstance(ro).getMetadataContainers("Required");
			try {
				pp.process(ro, containers[0] as IMetadataContainer, "Required", "requiredTest");
				fail("ObjectWithRequiredProperty should be invalid");
			} catch (e:Error) {
				assertTrue(true);
			}
		}

	}
}