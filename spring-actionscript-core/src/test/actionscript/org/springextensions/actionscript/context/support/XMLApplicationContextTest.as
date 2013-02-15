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
package org.springextensions.actionscript.context.support {

	import flash.display.Stage;
	import flash.events.Event;

	import mx.containers.VBox;

	import org.as3commons.lang.IllegalStateError;
	import org.springextensions.actionscript.EmbeddedContext;
	import org.springextensions.actionscript.ioc.factory.config.flex.FlexPropertyPlaceholderConfigurer;
	import org.springextensions.actionscript.ioc.factory.support.UnsatisfiedDependencyError;
	import org.springextensions.actionscript.ioc.testclasses.Person;
	import org.springextensions.actionscript.objects.testclasses.AdresFactory;
	import org.springextensions.actionscript.objects.testclasses.AnnotatedContact;
	import org.springextensions.actionscript.objects.testclasses.AnnotatedContactByType;
	import org.springextensions.actionscript.objects.testclasses.ConstructorContact;
	import org.springextensions.actionscript.objects.testclasses.Contact;
	import org.springextensions.actionscript.objects.testclasses.DisplayContact;
	import org.springextensions.actionscript.objects.testclasses.ImplementsTestInterfaceWithInitMethod;
	import org.springextensions.actionscript.objects.testclasses.ImplementsTestInterfaceWithSimpleProperty;
	import org.springextensions.actionscript.objects.testclasses.InternationalPhoneNumber;
	import org.springextensions.actionscript.objects.testclasses.PhoneNumber;
	import org.springextensions.actionscript.objects.testclasses.PhoneNumberEditor;
	import org.springextensions.actionscript.objects.testinterfaces.ITestInterfaceWithInitMethod;
	import org.springextensions.actionscript.objects.testinterfaces.ITestInterfaceWithSimpleProperty;
	import org.springextensions.actionscript.stage.DefaultAutowiringStageProcessor;
	import org.springextensions.actionscript.stage.FlashStageProcessorRegistry;
	import org.springextensions.actionscript.test.SASTestCase;
	import org.springextensions.actionscript.utils.ApplicationUtils;

	/**
	 * @author Christophe Herreman
	 */
	public class XMLApplicationContextTest extends SASTestCase {

		private var _context:XMLApplicationContext;

		// force compilation
		{
			PhoneNumber;
			PhoneNumberEditor;
			Contact;
			AnnotatedContactByType;
			ITestInterfaceWithInitMethod;
			ITestInterfaceWithSimpleProperty;
			ImplementsTestInterfaceWithSimpleProperty;
			ImplementsTestInterfaceWithInitMethod;
		}

		public function XMLApplicationContextTest(methodName:String = null) {
			super(methodName);
		}


		override public function setUp():void {
			super.setUp();
			_context = new XMLApplicationContext();
		}

		override public function tearDown():void {
			super.tearDown();
			_context.dispose();
			_context = null;
		}

		public function testStageAutowire():void {
			var a:DefaultAutowiringStageProcessor;
			var b:FlexPropertyPlaceholderConfigurer;
			var stage:Stage = ApplicationUtils.application.systemManager.stage;
			FlashStageProcessorRegistry.getInstance().stage = stage;
			_context.addConfigLocation("context-with-stage-annotations-autowire.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onTestStageAutowireLoadComplete, 1000));
			_context.load();
		}

		private function onTestStageAutowireLoadComplete(event:Event):void {
			var displayContact:DisplayContact = new DisplayContact();
			var displayContact2:DisplayContact = new DisplayContact();

			var phoneNumber:PhoneNumber = _context.getObject("phoneNumber");
			var phoneNumber2:PhoneNumber = _context.getObject("phoneNumber2");
			var phoneNumber3:PhoneNumber = _context.getObject("phoneNumber3");

			displayContact.name = "wireContact1";
			displayContact2.name = "contact1";
			displayContact.note = "Unchanged note";
			displayContact2.note = "Unchanged note";
			displayContact.phoneNumber3 = _context.getObject("phoneNumber3");
			displayContact2.phoneNumber3 = _context.getObject("phoneNumber3");

			ApplicationUtils.addChild(displayContact);
			ApplicationUtils.addChild(displayContact2);

			assertEquals(phoneNumber, displayContact.phoneNumber); // Autowire by type
			assertEquals(phoneNumber2, displayContact.phoneNumber2); // Autowire by name
			assertEquals(phoneNumber3, displayContact.phoneNumber3); // No autowire
			assertEquals(displayContact.note, "Unchanged note"); // No autowire

			assertEquals(phoneNumber, displayContact2.phoneNumber); // Autowire by type
			assertEquals(phoneNumber2, displayContact2.phoneNumber2); // Autowire by name
			assertEquals(phoneNumber3, displayContact2.phoneNumber3); // No autowire
			assertEquals(displayContact.note, "Unchanged note"); // No autowire

			ApplicationUtils.removeChild(displayContact);
			ApplicationUtils.removeChild(displayContact2);

			// inner child components should also get autowired
			var vbox:VBox = new VBox();
			var displayContact3:DisplayContact = new DisplayContact();
			vbox.addChild(displayContact3);
			ApplicationUtils.addChild(vbox);

			assertEquals(phoneNumber, displayContact3.phoneNumber); // Autowire by type
			assertEquals(phoneNumber2, displayContact3.phoneNumber2); // Autowire by name
		}

		public function testParse_shouldApplyConstructorArgumentsAndInvokeMethod():void {
			_context.addConfigLocation("context-with-method-invocation.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(load_completeHandler, 1000));
			_context.load();
		}

		public function load_completeHandler(event:Event):void {
			trace();
			var bert:Person = _context.getObject("bert");
			trace();
			assertEquals("Bert Vandamme", bert.name);
			assertEquals(1, bert.friends.length);
			var friend:Person = bert.friends[0];
			assertEquals("Christophe Herreman", friend.name);

			bert = _context.getObject("bertPrototype");
			friend = bert.friends[0];
			assertEquals("Christophe Herreman", friend.name);

			var bert2:Person = _context.getObject("bertPrototype");
			assertFalse(bert === bert2);
			friend = bert.friends[0];
			assertEquals("Christophe Herreman", friend.name);

		}

		public function testParse_shouldApplyCustomPropertyEditors():void {
			_context.addConfigLocation("context-with-custom-editors.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(function(event:Event):void {
				trace("");
			}, 1000));
			_context.load();
		}

		// TODO fix this - discuss with Roland
		/*public function testAutowireWithPropertyName():void {
		   _context = new XMLApplicationContext("context-with-autowire-propertyname.xml");
		   _context.addEventListener(Event.COMPLETE, addAsync(onTestAutowireWithPropertyName, 1000));
		   _context.load();
		   }

		   private function onTestAutowireWithPropertyName(event:Event):void {
		   var testProp:TestClassWithInjectPropertyName = _context.getObject('testPropInjection');

		   assertEquals("First string", testProp.injectedProperty);
		 }*/

		// ------------------------------------------------------------------------
		// Test: Constructor
		// ------------------------------------------------------------------------

		public function testNewWithoutSource():void {
			var factory:XMLApplicationContext = new XMLApplicationContext();
			assertEquals(0, factory.configLocations.length);
		}

		public function testNewWithSourceString():void {
			var factory:XMLApplicationContext = new XMLApplicationContext("test.xml");
			assertEquals(1, factory.configLocations.length);
		}

		public function testNewWithSourceArray():void {
			var factory:XMLApplicationContext = new XMLApplicationContext(["test.xml", "test3.xml", "test3.xml"]);
			assertEquals(3, factory.configLocations.length);
		}


		// ------------------------------------------------------------------------
		// Test: load()
		// ------------------------------------------------------------------------

		/*public function testLoad_shouldThrowIllegalStateErrorWhenNoConfigLocationsOrXMLHasBeenAdded():void {
			try {
				_context.load();
				fail("Loading an XMLObjectFactory with no config locations or XML set should fail.");
			} catch (e:IllegalStateError) {
			}
		}*/

		public function testLoadWithOneConfigLocationWithImport():void {
			_context.addConfigLocation("context-with-import.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onLoadCompleteWithOneConfigLocationWithImport, 2000));
			_context.load();
		}

		private function onLoadCompleteWithOneConfigLocationWithImport(event:Event):void {
			assertNotNull(_context);
			assertEquals(2, _context.numObjectDefinitions);
			var to:ImplementsTestInterfaceWithSimpleProperty = _context.getObject('testImpl');
			assertEquals("test value", to.testProperty);
		}

		public function testLoadWithOneConfigLocationWithDoubleImport():void {
			_context.addConfigLocation("context-with-import2.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onLoadCompleteWithOneConfigLocationWithDoubleImport, 2000));
			_context.load();
		}

		private function onLoadCompleteWithOneConfigLocationWithDoubleImport(event:Event):void {
			assertNotNull(_context);
			assertEquals(3, _context.numObjectDefinitions);
		}

		public function testLoadWithOneConfigLocationWithoutPropertyFiles():void {
			_context.addConfigLocation("context.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onLoadComplete, 2000));
			_context.load();
		}

		private function onLoadComplete(event:Event):void {
			assertNotNull(_context);
			assertEquals(1, _context.numObjectDefinitions);
		}

		public function testLoadWithNamespaceSupport():void {
			_context.addConfigLocation("context-with-ns-defined.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onLoadWithNamespaceSupportComplete, 2000));
			_context.load();
		}

		private function onLoadWithNamespaceSupportComplete(event:Event):void {
			assertNotNull(_context);
			assertEquals(5, _context.numObjectDefinitions);
		}

		public function testLoadWithNamespaceAndPrefixSupport():void {
			_context.addConfigLocation("context-with-ns-and-prefix.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onLoadWithNamespaceAndPrefixSupport, 2000));
			_context.load();
		}

		private function onLoadWithNamespaceAndPrefixSupport(event:Event):void {
			assertNotNull(_context);
			assertEquals(2, _context.numObjectDefinitions);
		}

		public function testLoadWithPropertyTag():void {
			_context.addConfigLocation("context-with-property-tag.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onLoadWithPropertyTagComplete, 2000));
			_context.load();
		}

		private function onLoadWithPropertyTagComplete(event:Event):void {
			assertNotNull(_context);
			assertEquals(5, _context.numObjectDefinitions);

			var string1:String = _context.getObject("string1");
			assertEquals("First string", string1);

			var string2:String = _context.getObject("string2");
			assertEquals("Second string", string2);

			var o:Object = _context.getObject("o");
			assertNotNull(o);
			assertNotNull(o.a);
			assertEquals(2, o.a.length);
		}


		// TODO TBD we should probably introduce order to the PropertyPlaceholderConfigurer since there is no
		// guarantee that the first declared one is loaded before the other one
		// hence this test will fail some times as it is right now
		/*public function testLoadWithMultiplePropertyTags():void {
		   _context.addConfigLocation("context-with-multiple-property-tags.xml");
		   _context.addEventListener(Event.COMPLETE, addAsync(onLoadWithMultiplePropertyTagsComplete, 2000));
		   _context.load();
		   }

		   private function onLoadWithMultiplePropertyTagsComplete(event:Event):void {
		   assertNotNull(_context);
		   assertEquals(6, _context.numObjectDefinitions);

		   var string1:String = _context.getObject("string1");
		   assertEquals("First overridden string", string1);

		   var string2:String = _context.getObject("string2");
		   assertEquals("Second overridden string", string2);

		   var o:Object = _context.getObject("o");
		   assertNotNull(o);
		   assertNotNull(o.a);
		   assertEquals(2, o.a.length);
		 }*/

		public function testLoadWithNonRequiredPropertyTag():void {
			_context.addConfigLocation("context-with-non-required-property-tag.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onLoadWithNonRequiredPropertyTagComplete, 2000));
			_context.load();
		}

		private function onLoadWithNonRequiredPropertyTagComplete(event:Event):void {
			assertNotNull(_context);
			assertEquals(5, _context.numObjectDefinitions);

			var string1:String = _context.getObject("string1");
			assertEquals("${s1}", string1);

			var string2:String = _context.getObject("string2");
			assertEquals("${s2}", string2);

			var o:Object = _context.getObject("o");
			assertNotNull(o);
			assertNotNull(o.a);
			assertEquals(2, o.a.length);
		}

		//

		public function testLoadWithMultipleConfigLocations():void {
			_context.addConfigLocation("context.xml");
			_context.addConfigLocation("context-with-property-tag.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onLoadCompleteWithMultipleConfigLocations, 3000));
			_context.load();
		}

		private function onLoadCompleteWithMultipleConfigLocations(event:Event):void {
			assertNotNull(_context);
			assertEquals(5, _context.numObjectDefinitions); // 4 instead of 5 because "string1" is overridden

			// should override the string1 property in the first context?
			var string1:String = _context.getObject("string1");
			assertEquals("First string", string1);
		}

		public function testLoadWithEmbeddedConfig():void {
			var context:EmbeddedContext = new EmbeddedContext();

			_context.addConfig(context.content);
			_context.addEventListener(Event.COMPLETE, addAsync(onLoadCompleteWithEmbeddedConfig, 2000));
			_context.load();
		}

		private function onLoadCompleteWithEmbeddedConfig(event:Event):void {
			assertNotNull(_context);
			assertEquals(1, _context.numObjectDefinitions);
		}

		// --------------------------------------------------------------------
		//
		// Autowire tests
		//
		// --------------------------------------------------------------------

		public function testLoadWithAutoWireByName():void {
			_context.addConfigLocation("context-with-autowire-byname.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onLoadWithAutoWireByNameComplete, 2000));
			_context.load();
		}

		private function onLoadWithAutoWireByNameComplete(event:Event):void {
			assertNotNull(_context);
			//throw new Error("XML: " + MetadataUtils.getFromObject(InternationalPhoneNumber));
			var contact:Contact = _context.getObject("contact");
			var phoneNumber:PhoneNumber = _context.getObject("phoneNumber");
			var contact2:Contact = _context.getObject("contact2");
			var phoneNumber2:PhoneNumber = _context.getObject("phoneNumber2");
			var contact3:Contact = _context.getObject("contact3");

			// Contact one had just phoneNumber autowired because phoneNumber2 is not
			// an autowire candidate
			assertNotNull(phoneNumber);
			assertNotNull(contact);
			assertNotNull(contact.phoneNumber);
			assertEquals(phoneNumber, contact.phoneNumber);
			assertNull(contact.phoneNumber2);

			// Contact 2 explicitly wire phoneNumber2
			assertNotNull(contact2);
			assertNotNull(contact2.phoneNumber);
			assertEquals(phoneNumber, contact.phoneNumber);
			assertNotNull(contact2.phoneNumber2);
			assertEquals(phoneNumber2, contact2.phoneNumber2);

			// Contact 3 explicitly wire both phoneNumbers in reverse
			// order overriding the autowire settings
			assertNotNull(contact3);
			assertNotNull(contact3.phoneNumber);
			assertEquals(phoneNumber2, contact3.phoneNumber);
			assertNotNull(contact3.phoneNumber2);
			assertEquals(phoneNumber, contact3.phoneNumber2);
		}

		public function testLoadWithAutoWireByType():void {
			_context.addConfigLocation("context-with-autowire-bytype.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onLoadWithAutoWireByTypeComplete, 2000));
			_context.load();
		}

		private function onLoadWithAutoWireByTypeComplete(event:Event):void {
			assertNotNull(_context);
			var contact:Contact = _context.getObject("contact");
			var phoneNumber:PhoneNumber = _context.getObject("phoneNumber");
			var contact2:Contact = _context.getObject("contact2");
			var phoneNumber2:PhoneNumber = _context.getObject("phoneNumber2");
			var contact3:Contact = _context.getObject("contact3");
			var phoneNumber3:PhoneNumber = _context.getObject("phoneNumber3");
			var adresFactory:AdresFactory = _context.getObject("&adresFactory");

			assertNotNull(phoneNumber);
			assertNotNull(phoneNumber2);
			assertNotNull(phoneNumber3);
			assertNotNull(contact);
			assertNotNull(contact2);
			assertNotNull(contact3);

			// Note is not autowired being a "simple value type"
			// CH (2/6/2009): autowiring simple types is enabled for now
			//assertNull(contact.note);

			// Contact one wire both properties to phoneNumber because phoneNumber2 is not
			// an autowire candidate, and phoneNumber is primary
			assertNotNull(contact.phoneNumber);
			assertEquals(phoneNumber, contact.phoneNumber);
			assertNotNull(contact.phoneNumber2);
			assertEquals(phoneNumber, contact.phoneNumber2);
			assertNotNull(contact.adres);

			// Contact 2 explicitly wire phoneNumber2 overriding phoneNumber2 autowire
			assertNotNull(contact2.phoneNumber);
			assertEquals(phoneNumber, contact.phoneNumber);
			assertNotNull(contact2.phoneNumber2);
			assertEquals(phoneNumber2, contact2.phoneNumber2);
			assertNotNull(contact2.adres);

			// Contact 3 explicitly wire both phoneNumbers in reverse
			// order overriding the autowire settings
			assertNotNull(contact3.phoneNumber);
			assertEquals(phoneNumber2, contact3.phoneNumber);
			assertNotNull(contact3.phoneNumber2);
			assertEquals(phoneNumber, contact3.phoneNumber2);
			assertNotNull(contact3.adres);
		}

		public function testLoadWithAnnotatedAutoWire():void {
			_context.addConfigLocation("context-with-annotation-autowire.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onLoadWithAnnotatedAutoWire, 2000));
			_context.load();
		}

		private function onLoadWithAnnotatedAutoWire(event:Event):void {
			assertNotNull(_context);
			var contact:AnnotatedContact = _context.getObject("contact");
			var contact2:Contact = _context.getObject("contact2");
			var phoneNumber:PhoneNumber = _context.getObject("phoneNumber");
			var phoneNumber2:PhoneNumber = _context.getObject("phoneNumber2");

			// Annotation autowired
			assertNotNull(phoneNumber);
			assertNotNull(contact);
			assertNotNull(contact.phoneNumber);
			assertEquals(phoneNumber, contact.phoneNumber);
			assertNull(contact.phoneNumber2);

			// No annotation Autowired
			assertNotNull(contact2);
			assertNull(contact2.phoneNumber);
			assertNull(contact2.phoneNumber2);

		}

		public function testAutoWireConstructor():void {
			_context.addConfigLocation("context-with-autowire-constructor.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onLoadAutoWireConstructorComplete, 2000));
			_context.load();
		}

		private function onLoadAutoWireConstructorComplete(event:Event):void {
			assertNotNull(_context);
			var ccontact:ConstructorContact = _context.getObject("constructorContact");
			var phoneNumber:InternationalPhoneNumber = _context.getObject("phoneNumber");
			var phoneNumber2:PhoneNumber = _context.getObject("phoneNumber2");
			var phoneNumber3:PhoneNumber = _context.getObject("phoneNumber3");

			assertNotNull(phoneNumber);
			assertNotNull(phoneNumber2);
			assertNotNull(phoneNumber3);
			assertNotNull(ccontact);
			assertNotNull(ccontact.phoneNumber);
			assertEquals(phoneNumber2, ccontact.phoneNumber);
			assertNotNull(ccontact.phoneNumber2);
			assertEquals(phoneNumber3, ccontact.phoneNumber2);
			assertNotNull(ccontact.hiddenPhone);
			assertEquals(phoneNumber, ccontact.hiddenPhone);

			var cpcontact:ConstructorContact = _context.getObject("prototypedConstructorContact");

			assertNotNull(cpcontact);
			assertNotNull(cpcontact.phoneNumber);
			assertEquals(phoneNumber2, cpcontact.phoneNumber);
			assertNotNull(cpcontact.phoneNumber2);
			assertEquals(phoneNumber3, cpcontact.phoneNumber2);
			assertNotNull(cpcontact.hiddenPhone);
			assertEquals(phoneNumber, cpcontact.hiddenPhone);

		}

		public function testAutoWireAutodetectByType():void {
			_context.addConfigLocation("context-with-autowire-autodetect-bytype.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onLoadAutoWireAutodetectByTypeComplete, 2000));
			_context.load();
		}

		// BYTYPE detected, should behave exactly like testAutoWireByType()
		private function onLoadAutoWireAutodetectByTypeComplete(event:Event):void {
			assertNotNull(_context);
			var contact:Contact = _context.getObject("contact");
			var phoneNumber:PhoneNumber = _context.getObject("phoneNumber");
			var contact2:Contact = _context.getObject("contact2");
			var phoneNumber2:PhoneNumber = _context.getObject("phoneNumber2");
			var contact3:Contact = _context.getObject("contact3");
			var phoneNumber3:PhoneNumber = _context.getObject("phoneNumber3");

			assertNotNull(phoneNumber);
			assertNotNull(phoneNumber2);
			assertNotNull(phoneNumber3);
			assertNotNull(contact);
			assertNotNull(contact2);
			assertNotNull(contact3);

			assertNotNull(contact.phoneNumber);
			assertEquals(phoneNumber, contact.phoneNumber);
			assertNotNull(contact.phoneNumber2);
			assertEquals(phoneNumber, contact.phoneNumber2);

			assertNotNull(contact2.phoneNumber);
			assertEquals(phoneNumber, contact.phoneNumber);
			assertNotNull(contact2.phoneNumber2);
			assertEquals(phoneNumber2, contact2.phoneNumber2);

			assertNotNull(contact3.phoneNumber);
			assertEquals(phoneNumber2, contact3.phoneNumber);
			assertNotNull(contact3.phoneNumber2);
			assertEquals(phoneNumber, contact3.phoneNumber2);
		}

		public function testAutoWireAutodetectConstructor():void {
			_context.addConfigLocation("context-with-autowire-autodetect-constructor.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onLoadAutoWireAutodetectConstructorComplete, 2000));
			_context.load();
		}

		// CONSTRUCTOR detected, should behave exactly like testAutoWireConstructor()
		private function onLoadAutoWireAutodetectConstructorComplete(event:Event):void {
			assertNotNull(_context);
			var ccontact:ConstructorContact = _context.getObject("constructorContact");
			var phoneNumber:InternationalPhoneNumber = _context.getObject("phoneNumber");
			var phoneNumber2:PhoneNumber = _context.getObject("phoneNumber2");
			var phoneNumber3:PhoneNumber = _context.getObject("phoneNumber3");

			assertNotNull(phoneNumber);
			assertNotNull(phoneNumber2);
			assertNotNull(phoneNumber3);
			assertNotNull(ccontact);
			assertNotNull(ccontact.phoneNumber);
			assertEquals(phoneNumber2, ccontact.phoneNumber);
			assertNotNull(ccontact.phoneNumber2);
			assertEquals(phoneNumber3, ccontact.phoneNumber2);
			assertNotNull(ccontact.hiddenPhone);
			assertEquals(phoneNumber, ccontact.hiddenPhone);

		}

		public function testLoadWithAutoWireByTypeAndDependencyCheck():void {
			_context.addConfigLocation("context-with-autowire-bytype-and-dependency-check.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onLoadWithAutoWireByTypeAndDependencyCheckComplete, 2000));
			_context.load();
		}

		private function onLoadWithAutoWireByTypeAndDependencyCheckComplete(event:Event):void {
			assertNotNull(_context);

			// OBJECTS
			try {
				var contact:Contact = _context.getObject("contact");
				fail("Creating object 'contact' was supposed to throw an UnsatisfiedDependencyError");
			} catch (e:UnsatisfiedDependencyError) {
				assertEquals("contact", e.objectName);
				assertEquals("adres", e.propertyName);
			}

			// ALL
			try {
				var contact2:Contact = _context.getObject("contact2");
				fail("Creating object 'contact2' was supposed to throw an UnsatisfiedDependencyError");
			} catch (e:UnsatisfiedDependencyError) {
				assertEquals("contact2", e.objectName);
				// We will either get an error on "note" or "adres" here, since the order of dependency resolution
				// is not the same every time.
				assertTrue(e.propertyName == "adres" || e.propertyName == "note");
			}

			// SIMPLE
			try {
				var contact3:Contact = _context.getObject("contact3");
				fail("Creating object 'contact3' was supposed to throw an UnsatisfiedDependencyError");
			} catch (e:UnsatisfiedDependencyError) {
				assertEquals("contact3", e.objectName);
				assertEquals("note", e.propertyName);
			}

			// NONE
			try {

				var contact4:Contact = _context.getObject("contact4");
				var phoneNumber:PhoneNumber = _context.getObject("phoneNumber");
				assertNotNull(contact4);
				assertNotNull(phoneNumber);
				assertNotNull(contact4.phoneNumber);
				assertEquals(phoneNumber, contact4.phoneNumber);
				assertNotNull(contact4.phoneNumber2);
				assertEquals(phoneNumber, contact4.phoneNumber2);
				assertNull(contact4.note);
				assertNull(contact4.adres);

			} catch (e:UnsatisfiedDependencyError) {
				fail("Creating object 'contact4' was not supposed to throw an UnsatisfiedDependencyError");
			}
		}

		public function testLoadWithAnnotationAutoWireAndMissingDependencies():void {
			_context.addConfigLocation("context-with-annotation-autowire-and-missing-dependencies.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onLoadWithAnnotationAutoWireAndMissingDependencies, 2000));
			_context.load();
		}

		private function onLoadWithAnnotationAutoWireAndMissingDependencies(event:Event):void {
			assertNotNull(_context);

			// OBJECTS
			try {
				var contact:AnnotatedContact = _context.getObject("contact");
				fail("Creating object 'contact' was supposed to throw an UnsatisfiedDependencyError");
			} catch (e:UnsatisfiedDependencyError) {
				assertEquals("contact", e.objectName);
				assertEquals("phoneNumber", e.propertyName);
			}

			try {
				var contact2:AnnotatedContactByType = _context.getObject("contact2");
				fail("Creating object 'contact2' was supposed to throw an UnsatisfiedDependencyError");
			} catch (e:UnsatisfiedDependencyError) {
				assertEquals("contact2", e.objectName);
				assertEquals("phoneNumber", e.propertyName);
			}
		}


	}
}
