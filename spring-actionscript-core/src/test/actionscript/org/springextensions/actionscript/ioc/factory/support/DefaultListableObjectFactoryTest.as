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
package org.springextensions.actionscript.ioc.factory.support {

	import flexunit.framework.TestCase;

	import org.as3commons.lang.IllegalArgumentError;
	import org.as3commons.lang.ObjectUtils;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.ObjectDefinition;
	import org.springextensions.actionscript.ioc.ObjectDefinitionNotFoundError;
	import org.springextensions.actionscript.ioc.factory.NoSuchObjectDefinitionError;
	import org.springextensions.actionscript.ioc.factory.ObjectDefinitionStoreError;
	import org.springextensions.actionscript.ioc.factory.config.RequiredMetadataProcessor;
	import org.springextensions.actionscript.ioc.factory.config.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.testclasses.Collaborator;
	import org.springextensions.actionscript.ioc.testclasses.Mediator;
	import org.springextensions.actionscript.ioc.testclasses.Person;
	import org.springextensions.actionscript.ioc.testclasses.PersonRequiredName;
	import org.springextensions.actionscript.metadata.MetadataProcessorObjectPostProcessor;

	/**
	 * @author Christophe Herreman
	 */
	public class DefaultListableObjectFactoryTest extends TestCase {

		private var _objectFactory:DefaultListableObjectFactory;

		public function DefaultListableObjectFactoryTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			_objectFactory = new DefaultListableObjectFactory();

			var personDefinition:IObjectDefinition = new ObjectDefinition("org.springextensions.actionscript.ioc.testclasses.Person");
			personDefinition.properties["name"] = "Christophe Herreman";
			personDefinition.properties["age"] = 26;
			personDefinition.properties["isMarried"] = true;

			_objectFactory.registerObjectDefinition("person", personDefinition);

			var singletonDefinition:IObjectDefinition = new ObjectDefinition("Object");
			singletonDefinition.isSingleton = true;

			_objectFactory.registerObjectDefinition("singletonObject", singletonDefinition);

			var prototypeDefinition:IObjectDefinition = new ObjectDefinition("Object");
			prototypeDefinition.isSingleton = false;

			_objectFactory.registerObjectDefinition("prototypeObject", prototypeDefinition);

			prototypeDefinition = new ObjectDefinition(Type.forClass(RequiredMetadataProcessor).fullName);
			_objectFactory.registerObjectDefinition("requiredMetaDataProcessor", prototypeDefinition);

			var personRequiredNameDefinition:IObjectDefinition = new ObjectDefinition("org.springextensions.actionscript.ioc.testclasses.PersonRequiredName");
			personRequiredNameDefinition.properties["age"] = 26;
			personRequiredNameDefinition.properties["isMarried"] = true;

			_objectFactory.registerObjectDefinition("personRequiredName", personRequiredNameDefinition);

			// static factory method
			var personDefinitionStatic:IObjectDefinition = new ObjectDefinition("org.springextensions.actionscript.ioc.testclasses.Person");
			personDefinitionStatic.factoryMethod = "createPerson";
			personDefinitionStatic.constructorArguments = ["Christophe Herreman", 27];
			_objectFactory.registerObjectDefinition("personViaStaticFactoryMethod", personDefinitionStatic);

			var personDefinitionStaticWithWrongArgumentTypes:IObjectDefinition = new ObjectDefinition("org.springextensions.actionscript.ioc.testclasses.Person");
			personDefinitionStaticWithWrongArgumentTypes.factoryMethod = "createPerson";
			personDefinitionStaticWithWrongArgumentTypes.constructorArguments = ["Christophe Herreman", "27"];
			_objectFactory.registerObjectDefinition("personStaticWithWrongArgumentTypes", personDefinitionStaticWithWrongArgumentTypes);

			// OR container.objectDefinitions.myPerson = personDefinition;
			var proc:MetadataProcessorObjectPostProcessor = new MetadataProcessorObjectPostProcessor();
			proc.objectFactory = _objectFactory;
			_objectFactory.addObjectPostProcessor(proc);
			proc.afterPropertiesSet();
		}

		public function testGetObject():void {
			try {
				var myPerson:Person = _objectFactory.getObject("person") as Person;
				assertNotNull(myPerson);
				assertEquals("Christophe Herreman", myPerson.name);
				assertEquals(26, myPerson.age);
				assertTrue(myPerson.isMarried);
			} catch (e:ReferenceError) {
				trace("ReferenceError: " + e.message);
				fail(e.message);
			} catch (e:ObjectDefinitionNotFoundError) {
				trace("ObjectDef not found");
				fail(e.message);
			}
		}

		public function testCreateInstance():void {
			var myPerson:Person = _objectFactory.createInstance(Person, ["Christophe Herreman", 26, true]);
			assertNotNull(myPerson);
			assertEquals("Christophe Herreman", myPerson.name);
			assertEquals(26, myPerson.age);
			assertTrue(myPerson.isMarried);
		}

		public function testGetObject_shouldThrowErrorRequiredProperty():void {
			try {
				var myPerson:PersonRequiredName = _objectFactory.getObject("personRequiredName");
				fail("Calling getObject() for object that contains a required property should throw an error");
			} catch (e:Error) {
				assertTrue(true);
			}
		}

		public function testGetObjectSingleton():void {
			var person1:Person = _objectFactory.getObject("person");
			var person2:Person = _objectFactory.getObject("person");
			assertEquals(person1, person2);
		}

		public function testGetObjectPrototype():void {
			var personDefinition:IObjectDefinition = _objectFactory.getObjectDefinition("person");
			personDefinition.isSingleton = false;
			var person1:Person = _objectFactory.getObject("person");
			var person2:Person = _objectFactory.getObject("person");
			assertFalse(person1 == person2);
		}

		public function testGetObject_viaStaticFactoryMethod():void {
			var person:Person = _objectFactory.getObject("personViaStaticFactoryMethod");
			assertNotNull(person);
			assertEquals("Christophe Herreman", person.name);
			assertEquals(27, person.age);
		}

		public function testGetObject_viaStaticFactoryMethodWithWrongArgumentTypes():void {
			var person:Person = _objectFactory.getObject("personStaticWithWrongArgumentTypes");
			assertNotNull(person);
			assertEquals("Christophe Herreman", person.name);
			assertEquals(27, person.age);
		}

		public function testContainsObject_shouldReturnTrueForExistingObjectDefinition():void {
			assertTrue(_objectFactory.containsObject("person"));
		}

		public function testContainsObject_shouldReturnFalseForNonExistingObjectDefinition():void {
			assertFalse(_objectFactory.containsObject("nonExistingObject"));
		}

		public function testIsSingleton_shouldReturnTreeByDefault():void {
			assertTrue(_objectFactory.isSingleton("person"));
		}

		public function testIsPrototype():void {
			assertTrue(_objectFactory.isPrototype("prototypeObject"));
		}

		public function testGetType_shouldReturnClassOfObjectDefinition():void {
			assertEquals(Person, _objectFactory.getType("person"));
		}

		public function testGetType_shouldThrowErrorForNonExistingObjectDefinition():void {
			try {
				_objectFactory.getType("nonExistingObject");
				fail("Calling getType() for non existing object should throw NoSuchObjectDefinitionError");
			} catch (e:NoSuchObjectDefinitionError) {
				assertEquals("nonExistingObject", e.objectName);
			}
		}

		public function testGetObject_shouldHandleCircularReference():void {
			var neededClasses:Array = [Collaborator, Mediator];
			var factory:DefaultListableObjectFactory = new DefaultListableObjectFactory();

			var collaboratorDef:ObjectDefinition = new ObjectDefinition("org.springextensions.actionscript.ioc.testclasses.Collaborator");
			collaboratorDef.properties["mediator"] = new RuntimeObjectReference("mediator");

			var mediatorDef:ObjectDefinition = new ObjectDefinition("org.springextensions.actionscript.ioc.testclasses.Mediator");
			mediatorDef.properties["collaborator"] = new RuntimeObjectReference("collaborator");

			factory.registerObjectDefinition("collaborator", collaboratorDef);
			factory.registerObjectDefinition("mediator", mediatorDef);

			var collaborator:Collaborator = factory.getObject("collaborator");
			var mediator:Mediator = factory.getObject("mediator");

			assertNotNull(collaborator);
			assertNotNull(mediator);
			assertNotNull(collaborator.mediator);
			assertNotNull(mediator.collaborator);
			assertEquals(collaborator, mediator.collaborator);
			assertEquals(mediator, collaborator.mediator);
		}

		// --------------------------------------------------------------------
		//
		// registerObjectDefinition
		//
		// --------------------------------------------------------------------

		public function testRegisterObjectDefinition_shouldFailForNullName():void {
			var factory:DefaultListableObjectFactory = new DefaultListableObjectFactory();

			try {
				factory.registerObjectDefinition(null, new ObjectDefinition("String"));
				fail("registerObjectDefinition(null, objectDefinition) should fail");
			} catch (e:IllegalArgumentError) {
			}
		}

		public function testRegisterObjectDefinition_shouldFailForEmptyName():void {
			var factory:DefaultListableObjectFactory = new DefaultListableObjectFactory();

			try {
				factory.registerObjectDefinition("", new ObjectDefinition("String"));
				fail("registerObjectDefinition('', objectDefinition) should fail");
			} catch (e:IllegalArgumentError) {
			}
		}

		public function testRegisterObjectDefinition_shouldFailForNameThatOnlyContainsSpaces():void {
			var factory:DefaultListableObjectFactory = new DefaultListableObjectFactory();

			try {
				factory.registerObjectDefinition("   ", new ObjectDefinition("String"));
				fail("registerObjectDefinition('   ', objectDefinition) should fail");
			} catch (e:IllegalArgumentError) {
			}
		}

		public function testRegisterObjectDefinition_shouldFailForNullObjectDefinition():void {
			var factory:DefaultListableObjectFactory = new DefaultListableObjectFactory();

			try {
				factory.registerObjectDefinition("myObject", null);
				fail("registerObjectDefinition('myObject', null) should fail");
			} catch (e:IllegalArgumentError) {
			}
		}

		public function testRegisterObjectDefinition_shouldFailWhenOverridingWhileItIsNotAllowed():void {
			var factory:DefaultListableObjectFactory = new DefaultListableObjectFactory();
			factory.allowObjectDefinitionOverriding = false;
			factory.registerObjectDefinition("myObject", new ObjectDefinition("String"));

			try {
				factory.registerObjectDefinition("myObject", new ObjectDefinition("String"));
				fail("registerObjectDefinition('myObject', new ObjectDefinition('String')) should fail when object name already registered");
			} catch (e:ObjectDefinitionStoreError) {
			}
		}

		// --------------------------------------------------------------------
		//
		// Tests: parentFactory
		//
		// --------------------------------------------------------------------

		public function testParentFactory():void {
			var parentFactory:DefaultListableObjectFactory = new DefaultListableObjectFactory();
			var objDef:ObjectDefinition = new ObjectDefinition("String");
			objDef.isLazyInit = true;
			parentFactory.registerObjectDefinition("myString", objDef);

			var factory:DefaultListableObjectFactory = new DefaultListableObjectFactory();
			factory.parent = parentFactory;

			var tst:String = factory.getObject("myString", ["teststring"]) as String;
			assertEquals("teststring", tst);
		}

		public function testParentFactoryWithReferenceOverride():void {
			var parentFactory:DefaultListableObjectFactory = new DefaultListableObjectFactory();
			var objDef:ObjectDefinition = new ObjectDefinition("String");
			objDef.constructorArguments.push("StringA");
			parentFactory.registerObjectDefinition("StringRefA", objDef);

			objDef = new ObjectDefinition("String");
			objDef.isLazyInit = true;
			objDef.isSingleton = false;
			objDef.constructorArguments.push(new RuntimeObjectReference("StringRefA"));
			parentFactory.registerObjectDefinition("myString", objDef);

			var factory:DefaultListableObjectFactory = new DefaultListableObjectFactory();
			factory.parent = parentFactory;
			objDef = new ObjectDefinition("String");
			objDef.constructorArguments.push("StringB");
			factory.registerObjectDefinition("StringRefA", objDef);

			var tst:String = factory.getObject("myString") as String;
			assertEquals("StringB", tst);
		}

		// --------------------------------------------------------------------
		//
		// Tests: getObjectNamesForType()
		//
		// --------------------------------------------------------------------

		public function testGetObjectNamesForType():void {
			var factory:DefaultListableObjectFactory = new DefaultListableObjectFactory();

			// register object definitions
			factory.registerObjectDefinition("s1", new ObjectDefinition("String"));
			factory.registerObjectDefinition("s2", new ObjectDefinition("String"));

			// register explicit singletons
			factory.registerSingleton("s3", "String 3");
			factory.registerSingleton("s4", "String 4");

			var names:Array = factory.getObjectNamesForType(String);
			assertNotNull(names);
			assertEquals(4, names.length);
			assertTrue(names.indexOf("s1") > -1);
			assertTrue(names.indexOf("s2") > -1);
			assertTrue(names.indexOf("s3") > -1);
			assertTrue(names.indexOf("s4") > -1);
		}

		// --------------------------------------------------------------------
		//
		// Tests: getObjectsOfType()
		//
		// --------------------------------------------------------------------

		public function testGetObjectsOfType():void {
			var factory:DefaultListableObjectFactory = new DefaultListableObjectFactory();

			// register object definitions
			factory.registerObjectDefinition("s1", new ObjectDefinition("String"));
			factory.registerObjectDefinition("s2", new ObjectDefinition("String"));

			// register explicit singletons
			factory.registerSingleton("s3", "String 3");
			factory.registerSingleton("s4", "String 4");

			var objects:Object = factory.getObjectsOfType(String);
			assertNotNull(objects);
			assertEquals(4, ObjectUtils.getNumProperties(objects));
			assertTrue(objects.hasOwnProperty("s1"));
			assertTrue(objects.hasOwnProperty("s2"));
			assertTrue(objects.hasOwnProperty("s3"));
			assertTrue(objects.hasOwnProperty("s4"));
		}

	}
}
