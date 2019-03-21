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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl {

	import org.as3commons.lang.ObjectUtils;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinition;

	/**
	 * @author Christophe Herreman
	 */
	public class ParsingUtilsTest {

		public function ParsingUtilsTest() {
			super();
		}

		[Test]
		public function testMapProperties():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition("");
			var xml:XML = <node an-attribute="a" another-attribute="b" yet-another-attribute="c"/>;

			ParsingUtils.mapProperties(null, objectDefinition, xml, "an-attribute", "another-attribute", new AttributeToPropertyMapping("yet-another-attribute", "YETAnotherAttribute"), "no-such-attribute");

			assertEquals("a", objectDefinition.getPropertyDefinitionByName("anAttribute").valueDefinition.value);
			assertEquals("b", objectDefinition.getPropertyDefinitionByName("anotherAttribute").valueDefinition.value);
			assertEquals("c", objectDefinition.getPropertyDefinitionByName("YETAnotherAttribute").valueDefinition.value);

			assertEquals(3, objectDefinition.properties.length);
			assertNull(objectDefinition.getPropertyDefinitionByName("no-such-attribute"));
			assertNull(objectDefinition.getPropertyDefinitionByName("noSuchAttribute"));
		}

		[Test]
		public function testMapPropertiesArrays():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition("");
			var xml:XML = <node an-attribute="a,b,c" another-attribute="b" yet-another-attribute="c,d"/>;

			ParsingUtils.mapPropertiesArrays(null, objectDefinition, xml, "an-attribute", "another-attribute", new AttributeToPropertyMapping("yet-another-attribute", "YETAnotherAttribute"), "no-such-attribute");

			assertPropertiesArray(objectDefinition, "anAttribute", ["a", "b", "c"]);
			assertPropertiesArray(objectDefinition, "anotherAttribute", ["b"]);
			assertPropertiesArray(objectDefinition, "YETAnotherAttribute", ["c", "d"]);

			assertEquals(3, objectDefinition.properties.length);
			assertNull(objectDefinition.getPropertyDefinitionByName("no-such-attribute"));
			assertNull(objectDefinition.getPropertyDefinitionByName("noSuchAttribute"));
		}

		[Test]
		public function testMapReferences():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition("");
			var xml:XML = <node an-attribute="a" another-attribute="b" yet-another-attribute="c"/>;

			ParsingUtils.mapReferences(null, objectDefinition, xml, "an-attribute", "another-attribute", new AttributeToPropertyMapping("yet-another-attribute", "YETAnotherAttribute"), "no-such-attribute");

			assertNotNull(objectDefinition.getPropertyDefinitionByName("anAttribute").valueDefinition.ref);
			assertNotNull(objectDefinition.getPropertyDefinitionByName("anotherAttribute").valueDefinition.ref);
			assertNotNull(objectDefinition.getPropertyDefinitionByName("YETAnotherAttribute").valueDefinition.ref);

			assertEquals("a", objectDefinition.getPropertyDefinitionByName("anAttribute").valueDefinition.ref.objectName);
			assertEquals("b", objectDefinition.getPropertyDefinitionByName("anotherAttribute").valueDefinition.ref.objectName);
			assertEquals("c", objectDefinition.getPropertyDefinitionByName("YETAnotherAttribute").valueDefinition.ref.objectName);

			assertEquals(3, objectDefinition.properties.length);
			assertNull(objectDefinition.getPropertyDefinitionByName("no-such-attribute"));
			assertNull(objectDefinition.getPropertyDefinitionByName("noSuchAttribute"));
		}

		[Test]
		public function testMapReferenceArrays():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition("");
			var xml:XML = <node an-attribute="a,b,c" another-attribute="b" yet-another-attribute="c,d"/>;

			ParsingUtils.mapReferenceArrays(null, objectDefinition, xml, "an-attribute", "another-attribute", new AttributeToPropertyMapping("yet-another-attribute", "YETAnotherAttribute"), "no-such-attribute");

			assertReferenceArray(objectDefinition, "anAttribute", ["a", "b", "c"]);
			assertReferenceArray(objectDefinition, "anotherAttribute", ["b"]);
			assertReferenceArray(objectDefinition, "YETAnotherAttribute", ["c", "d"]);

			assertEquals(3, objectDefinition.properties.length);
			assertNull(objectDefinition.getPropertyDefinitionByName("no-such-attribute"));
			assertNull(objectDefinition.getPropertyDefinitionByName("noSuchAttribute"));
		}

		/**
		 * Assertion to validate an array of properties
		 */
		public static function assertPropertiesArray(objectDefinition:IObjectDefinition, property:String, referenceNames:Array):void {
			assertNotNull(objectDefinition.getPropertyDefinitionByName(property));
			assertTrue(objectDefinition.getPropertyDefinitionByName(property).valueDefinition.value is Array);

			var arr:Array = objectDefinition.getPropertyDefinitionByName(property).valueDefinition.value as Array;
			for (var i:uint = 0; i < referenceNames.length; i++) {
				assertTrue(arr[i] is String);
				assertEquals(referenceNames[i], arr[i]);
			}
		}

		/**
		 * Assertion to validate an array of <code>RuntimeReference</code> objects
		 */
		public static function assertReferenceArray(objectDefinition:IObjectDefinition, property:String, referenceNames:Array):void {
			assertNotNull(objectDefinition.getPropertyDefinitionByName(property));
			assertTrue(objectDefinition.getPropertyDefinitionByName(property).valueDefinition.value is Array);

			var arr:Array = objectDefinition.getPropertyDefinitionByName(property).valueDefinition.value as Array;
			for (var i:uint = 0; i < referenceNames.length; i++) {
				assertTrue(arr[i] is RuntimeObjectReference);
				assertEquals(referenceNames[i], RuntimeObjectReference(arr[i]).objectName);
			}
		}
	}
}
