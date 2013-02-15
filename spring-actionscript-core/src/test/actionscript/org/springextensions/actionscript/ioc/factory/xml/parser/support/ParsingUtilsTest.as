package org.springextensions.actionscript.ioc.factory.xml.parser.support {
	
	import flexunit.framework.TestCase;
	
	import org.as3commons.lang.ObjectUtils;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.ObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.config.RuntimeObjectReference;
	
	/**
	 * @author Christophe Herreman
	 */
	public class ParsingUtilsTest extends TestCase {
		
		public function ParsingUtilsTest(methodName:String = null) {
			super(methodName);
		}
		
		public function testMapProperties():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition("");
			var xml:XML =            <node an-attribute="a" another-attribute="b" yet-another-attribute="c"/>;
			
			ParsingUtils.mapProperties(objectDefinition, xml, "an-attribute", "another-attribute", new AttributeToPropertyMapping("yet-another-attribute", "YETAnotherAttribute"), "no-such-attribute");
			
			assertEquals("a", objectDefinition.properties["anAttribute"]);
			assertEquals("b", objectDefinition.properties["anotherAttribute"]);
			assertEquals("c", objectDefinition.properties["YETAnotherAttribute"]);
			
			assertEquals(3, ObjectUtils.getNumProperties(objectDefinition.properties));
			assertNull(objectDefinition.properties["no-such-attribute"]);
			assertNull(objectDefinition.properties["noSuchAttribute"]);
		}
		
		public function testMapPropertiesArrays():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition("");
			var xml:XML =    <node an-attribute="a,b,c" another-attribute="b" yet-another-attribute="c,d"/>;
			
			ParsingUtils.mapPropertiesArrays(objectDefinition, xml, "an-attribute", "another-attribute", new AttributeToPropertyMapping("yet-another-attribute", "YETAnotherAttribute"), "no-such-attribute");
			
			assertPropertiesArray(objectDefinition, "anAttribute", ["a", "b", "c"]);
			assertPropertiesArray(objectDefinition, "anotherAttribute", ["b"]);
			assertPropertiesArray(objectDefinition, "YETAnotherAttribute", ["c", "d"]);
			
			assertEquals(3, ObjectUtils.getNumProperties(objectDefinition.properties));
			assertNull(objectDefinition.properties["no-such-attribute"]);
			assertNull(objectDefinition.properties["noSuchAttribute"]);
		}
		
		public function testMapReferences():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition("");
			var xml:XML =           <node an-attribute="a" another-attribute="b" yet-another-attribute="c"/>;
			
			ParsingUtils.mapReferences(objectDefinition, xml, "an-attribute", "another-attribute", new AttributeToPropertyMapping("yet-another-attribute", "YETAnotherAttribute"), "no-such-attribute");
			
			assertTrue(objectDefinition.properties["anAttribute"] is RuntimeObjectReference);
			assertTrue(objectDefinition.properties["anotherAttribute"] is RuntimeObjectReference);
			assertTrue(objectDefinition.properties["YETAnotherAttribute"] is RuntimeObjectReference);
			
			assertEquals("a", RuntimeObjectReference(objectDefinition.properties["anAttribute"]).objectName);
			assertEquals("b", RuntimeObjectReference(objectDefinition.properties["anotherAttribute"]).objectName);
			assertEquals("c", RuntimeObjectReference(objectDefinition.properties["YETAnotherAttribute"]).objectName);
			
			assertEquals(3, ObjectUtils.getNumProperties(objectDefinition.properties));
			assertNull(objectDefinition.properties["no-such-attribute"]);
			assertNull(objectDefinition.properties["noSuchAttribute"]);
		}
		
		public function testMapReferenceArrays():void {
			var objectDefinition:IObjectDefinition = new ObjectDefinition("");
			var xml:XML =           <node an-attribute="a,b,c" another-attribute="b" yet-another-attribute="c,d"/>;
			
			ParsingUtils.mapReferenceArrays(objectDefinition, xml, "an-attribute", "another-attribute", new AttributeToPropertyMapping("yet-another-attribute", "YETAnotherAttribute"), "no-such-attribute");
			
			assertReferenceArray(objectDefinition, "anAttribute", ["a", "b", "c"]);
			assertReferenceArray(objectDefinition, "anotherAttribute", ["b"]);
			assertReferenceArray(objectDefinition, "YETAnotherAttribute", ["c", "d"]);
			
			assertEquals(3, ObjectUtils.getNumProperties(objectDefinition.properties));
			assertNull(objectDefinition.properties["no-such-attribute"]);
			assertNull(objectDefinition.properties["noSuchAttribute"]);
		}
		
		/**
		 * Assertion to validate an array of properties
		 */
		private function assertPropertiesArray(objectDefinition:IObjectDefinition, property:String, referenceNames:Array):void {
			assertNotNull(objectDefinition.properties[property]);
			assertTrue(objectDefinition.properties[property] is Array);
			
			for (var i:uint = 0; i < referenceNames.length; i++) {
				assertTrue(objectDefinition.properties[property][i] is String);
				assertEquals(referenceNames[i], objectDefinition.properties[property][i]);
			}
		}
		
		/**
		 * Assertion to validate an array of RuntimeReference objects
		 */
		private function assertReferenceArray(objectDefinition:IObjectDefinition, property:String, referenceNames:Array):void {
			assertNotNull(objectDefinition.properties[property]);
			assertTrue(objectDefinition.properties[property] is Array);
			
			for (var i:uint = 0; i < referenceNames.length; i++) {
				assertTrue(objectDefinition.properties[property][i] is RuntimeObjectReference);
				assertEquals(referenceNames[i], RuntimeObjectReference(objectDefinition.properties[property][i]).objectName);
			}
		}
	}
}