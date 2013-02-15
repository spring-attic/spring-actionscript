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

	import flash.events.Event;

	import mx.collections.ArrayCollection;
	import mx.containers.VBox;
	import mx.messaging.channels.AMFChannel;
	import mx.rpc.remoting.mxml.RemoteObject;

	import org.springextensions.actionscript.objects.testclasses.Contact;
	import org.springextensions.actionscript.objects.testclasses.DisplayContact;
	import org.springextensions.actionscript.objects.testclasses.DisplayContact2;
	import org.springextensions.actionscript.objects.testclasses.DisplayContactNoAutowire;
	import org.springextensions.actionscript.objects.testclasses.InternationalPhoneNumber;
	import org.springextensions.actionscript.objects.testclasses.ObjectFactoryAwareTest;
	import org.springextensions.actionscript.objects.testclasses.PhoneNumber;
	import org.springextensions.actionscript.objects.testclasses.PhoneNumberEditor;
	import org.springextensions.actionscript.objects.testclasses.ProductsTestObject;
	import org.springextensions.actionscript.objects.testclasses.TestClassWithInjectPropertyName;
	import org.springextensions.actionscript.objects.testclasses.TestModel;
	import org.springextensions.actionscript.stage.FlexStageProcessorRegistry;
	import org.springextensions.actionscript.stage.selectors.ClassBasedObjectSelector;
	import org.springextensions.actionscript.stage.selectors.NameBasedObjectSelector;
	import org.springextensions.actionscript.test.SASTestCase;
	import org.springextensions.actionscript.utils.ApplicationUtils;

	/**
	 * <p>
	 * <b>Author:</b> Martino Piccinato<br/>
	 * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public class FlexXMLApplicationContextTest extends SASTestCase {

		private var _context:FlexXMLApplicationContext = null;

		//private var _app:Application = new Application();

		// force compilation
		PhoneNumber;
		PhoneNumberEditor;
		Contact;
		InternationalPhoneNumber;
		DisplayContactNoAutowire;
		TestModel;
		ProductsTestObject;

		public function FlexXMLApplicationContextTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			super.setUp();
			_context = new FlexXMLApplicationContext();
		}

		override public function tearDown():void {
			super.tearDown();
			_context.dispose();
			_context = null;
		}

		public function testStageAutowire():void {
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

			assertStrictlyEquals(phoneNumber, displayContact.phoneNumber); // Autowire by type
			assertStrictlyEquals(phoneNumber2, displayContact.phoneNumber2); // Autowire by name
			assertStrictlyEquals(phoneNumber3, displayContact.phoneNumber3); // No autowire
			assertEquals(displayContact.note, "Unchanged note"); // No autowire

			assertStrictlyEquals(phoneNumber, displayContact2.phoneNumber); // Autowire by type
			assertStrictlyEquals(phoneNumber2, displayContact2.phoneNumber2); // Autowire by name
			assertStrictlyEquals(phoneNumber3, displayContact2.phoneNumber3); // No autowire
			assertEquals(displayContact.note, "Unchanged note"); // No autowire

			ApplicationUtils.removeChild(displayContact);
			ApplicationUtils.removeChild(displayContact2);

			// inner child components should also get autowired
			var vbox:VBox = new VBox();
			var displayContact3:DisplayContact = new DisplayContact();
			vbox.addChild(displayContact3);
			ApplicationUtils.addChild(vbox);

			assertStrictlyEquals(phoneNumber, displayContact3.phoneNumber); // Autowire by type
			assertStrictlyEquals(phoneNumber2, displayContact3.phoneNumber2); // Autowire by name
		}

		public function testStageAutowireWithNameFilter():void {
			_context.addConfigLocation("context-with-stage-annotations-autowire.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onTestStageAutowireWithNameFilterLoadComplete, 1000));
			_context.load();
		}

		private function onTestStageAutowireWithNameFilterLoadComplete(event:Event):void {

			var selector:NameBasedObjectSelector = new NameBasedObjectSelector();
			selector.nameRegexpArray = ["^otherprefix.*", "^wire.*"];

			var registry:FlexStageProcessorRegistry = FlexStageProcessorRegistry.getInstance();
			registry.getAllRegistrations()[0].objectSelector = selector;


			var displayContact:DisplayContact = new DisplayContact();
			var displayContact2:DisplayContact = new DisplayContact();

			var phoneNumber:PhoneNumber = _context.getObject("phoneNumber");
			var phoneNumber2:PhoneNumber = _context.getObject("phoneNumber2");
			var phoneNumber3:PhoneNumber = _context.getObject("phoneNumber3");

			displayContact.name = "wireContact2";
			displayContact2.name = "contact2";
			displayContact.note = "Unchanged note";
			displayContact2.note = "Unchanged note";
			displayContact.phoneNumber3 = _context.getObject("phoneNumber3");
			displayContact2.phoneNumber3 = _context.getObject("phoneNumber3");

			try {
				ApplicationUtils.addChild(displayContact);
				ApplicationUtils.addChild(displayContact2);

				assertStrictlyEquals(phoneNumber, displayContact.phoneNumber); // Autowire by type
				assertStrictlyEquals(phoneNumber2, displayContact.phoneNumber2); // Autowire by name
				assertStrictlyEquals(phoneNumber3, displayContact.phoneNumber3); // No autowire
				assertEquals(displayContact.note, "Unchanged note"); // No autowire

				// Do not wire on add event as its name does not match 
				// The passed filter
				assertNull(displayContact2.phoneNumber);
				assertNull(displayContact2.phoneNumber2);
				assertStrictlyEquals(phoneNumber3, displayContact2.phoneNumber3);
				assertEquals(displayContact2.note, "Unchanged note");
			} finally {
				ApplicationUtils.removeChild(displayContact);
				ApplicationUtils.removeChild(displayContact2);
			}
		}


		public function testStageAutowireWithClassFilter():void {
			_context.addConfigLocation("context-with-stage-annotations-autowire.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onTestStageAutowireWithClassFilterLoadComplete, 1000));
			_context.load();
		}

		private function onTestStageAutowireWithClassFilterLoadComplete(event:Event):void {
			var selector:ClassBasedObjectSelector = new ClassBasedObjectSelector();
			selector.classRegexpArray = ["org.springextensions.actionscript.objects.testclasses::DisplayContact2"];
			selector.approveOnMatch = true;

			FlexStageProcessorRegistry.getInstance().getAllRegistrations()[0].objectSelector = selector;

			var displayContact:DisplayContact = new DisplayContact();
			var displayContact2:DisplayContact2 = new DisplayContact2();

			var phoneNumber:PhoneNumber = _context.getObject("phoneNumber");
			var phoneNumber2:PhoneNumber = _context.getObject("phoneNumber2");
			var phoneNumber3:PhoneNumber = _context.getObject("phoneNumber3");

			displayContact.name = "wireContact3";
			displayContact2.name = "contact3";
			displayContact.note = "Unchanged note";
			displayContact2.note = "Unchanged note";
			displayContact.phoneNumber3 = _context.getObject("phoneNumber3");
			displayContact2.phoneNumber3 = _context.getObject("phoneNumber3");

			try {
				ApplicationUtils.addChild(displayContact);
				ApplicationUtils.addChild(displayContact2);

				assertStrictlyEquals(phoneNumber, displayContact2.phoneNumber); // Autowire by type
				assertStrictlyEquals(phoneNumber2, displayContact2.phoneNumber2); // Autowire by name
				assertStrictlyEquals(phoneNumber3, displayContact2.phoneNumber3); // No autowire
				assertEquals(displayContact.note, "Unchanged note"); // No autowire

				// Do not wire on stage add event as its class does is not in the approved class filter
				assertNull(displayContact.phoneNumber);
				assertNull(displayContact.phoneNumber2);
				assertStrictlyEquals(phoneNumber3, displayContact.phoneNumber3);
				assertEquals("Unchanged note", displayContact.note);
			} finally {
				ApplicationUtils.removeChild(displayContact);
				ApplicationUtils.removeChild(displayContact2);
			}
		}

		public function testStageObjectDefinition():void {
			_context.addConfigLocation("context-with-stage-objectdefinition.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onTestStageObjectDefinition, 1000));
			_context.load();
		}

		private function onTestStageObjectDefinition(event:Event):void {
			var displayContact:DisplayContactNoAutowire = new DisplayContactNoAutowire();
			var displayContact2:DisplayContactNoAutowire = new DisplayContactNoAutowire();

			var phoneNumber:PhoneNumber = _context.getObject("phoneNumber");

			displayContact.name = "contact1";
			displayContact2.name = "contact2";
			displayContact.note = "Changed note";
			displayContact2.note = "Changed note";

			try {
				ApplicationUtils.addChild(displayContact);
				ApplicationUtils.addChild(displayContact2);

				assertStrictlyEquals(phoneNumber, displayContact.phoneNumber);
				assertStrictlyEquals(phoneNumber, displayContact.phoneNumber2);
				assertStrictlyEquals(phoneNumber, displayContact.phoneNumber3);
				assertEquals("string", displayContact.note);

				assertStrictlyEquals(phoneNumber, displayContact2.phoneNumber);
				assertStrictlyEquals(phoneNumber, displayContact2.phoneNumber2);
				assertStrictlyEquals(phoneNumber, displayContact2.phoneNumber3);
				assertEquals("string", displayContact2.note);
			} finally {
				ApplicationUtils.removeChild(displayContact);
				ApplicationUtils.removeChild(displayContact2);
			}
		}

		public function testStageNamedObjectDefinition():void {
			_context.addConfigLocation("context-with-stage-namedobjectdefinition.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onTestStageNamedObjectDefinition, 1000));
			_context.load();
		}

		private function onTestStageNamedObjectDefinition(event:Event):void {

			var displayContact:DisplayContactNoAutowire = new DisplayContactNoAutowire();
			var displayContact2:DisplayContactNoAutowire = new DisplayContactNoAutowire();

			var phoneNumber:PhoneNumber = _context.getObject("phoneNumber");
			var phoneNumber2:PhoneNumber = _context.getObject("phoneNumber2");
			var phoneNumber3:PhoneNumber = _context.getObject("phoneNumber3");

			// It will be wired with non default object definition because there
			// is an object with the same name
			displayContact.name = "namedDisplayContact";

			// It will be wired default object definition (that won't override any property)
			displayContact2.name = "anotherName";

			try {
				ApplicationUtils.addChild(displayContact);
				ApplicationUtils.addChild(displayContact2);

				assertEquals(phoneNumber, displayContact.phoneNumber);
				assertEquals(phoneNumber2, displayContact.phoneNumber2);
				assertEquals(phoneNumber3, displayContact.phoneNumber3);

				assertNull(displayContact2.phoneNumber);
				assertNull(displayContact2.phoneNumber2);
				assertNull(displayContact2.phoneNumber3);
			} finally {
				ApplicationUtils.removeChild(displayContact);
				ApplicationUtils.removeChild(displayContact2);
			}
		}

		public function testAutowireWithBinding():void {
			_context.addConfigLocation("context-with-autowire-binding.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onTestAutowireWithBinding, 1000));
			_context.load();
		}

		private function onTestAutowireWithBinding(event:Event):void {
			var testProduct:ProductsTestObject = _context.getObject('productTest') as ProductsTestObject;
			var testModel:TestModel = _context.getObject('testModel') as TestModel;

			assertNotNull(testModel);
			assertNotNull(testProduct);
			assertNotNull(testProduct.products);

			var ac:ArrayCollection = new ArrayCollection(['product1', 'product2', 'product3']);
			testModel.products = ac;

			assertEquals(3, testProduct.products.length);

		}

		public function testSkipPostprocessor():void {
			_context.addConfigLocation("context-with-skip-postprocessor.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onTestSkipPostprocessor, 1000));
			_context.load();
		}

		private function onTestSkipPostprocessor(event:Event):void {
			var oat:ObjectFactoryAwareTest = _context.getObject("objectFactoryAwareTest") as ObjectFactoryAwareTest;
			assertNull(oat.objectFactory);
		}

		public function testSkipMetadata():void {
			_context.addConfigLocation("context-with-skip-metadata.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onTestSkipMetadata, 1000));
			_context.load();
		}

		private function onTestSkipMetadata(event:Event):void {
			var tmd:TestClassWithInjectPropertyName = _context.getObject("testMetadata") as TestClassWithInjectPropertyName;
			assertEquals("", tmd.injectedProperty);
		}

		// --------------------------------------------------------------------
		//
		// Test
		//
		// --------------------------------------------------------------------

		public function testLoadContextWithChannelSet():void {
			AMFChannel;
			RemoteObject;
			_context.addConfigLocation("context-channelset.xml");
			_context.addEventListener(Event.COMPLETE, addAsync(onLoadContextWithChannelSet, 2000));
			_context.load();
		}

		private function onLoadContextWithChannelSet(event:Event):void {
			assertNotNull(_context);
		}

	}
}
