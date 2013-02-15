package org.springextensions.actionscript {
	import flash.utils.describeType;
	
	import flexunit.framework.TestCase;
	
	// add all metadata the compiler should preserve here...
	// and add a check to the test method "testMetaDataPreservedByCompiler"
	[Required]
	[Autowired]
	
	/**
	 * Tests if certain metadata was preserved by the compiler.
	 *
	 * @author Christophe Herreman
	 */
	public class MetaDataInclusionTest extends TestCase {
		
		public function MetaDataInclusionTest(methodName:String = null) {
			super(methodName);
		}
		
		public function testMetaDataPreservedByCompiler():void {
			var description:XML = describeType(MetaDataInclusionTest);
			
			if (description.factory.hasOwnProperty("metadata")) {
				var metaDataNodes:XMLList = description.factory.metadata;
				assertHasMetaData(metaDataNodes, "Required");
				assertHasMetaData(metaDataNodes, "Autowired");
			} else {
				fail("No metadata was specified on the class 'MetaDataInclusionTest'");
			}
		}
		
		private function assertHasMetaData(metaDataNodes:XMLList, metaData:String):void {
			var message:String = "Is the '" + metaData + "' metadata tag specified in the compiler settings? (-keep-as3-metadata += " +
				metaData + ")";
			assertTrue(message, metaDataNodes.(attribute("name") == metaData).length() == 1);
		}
	}
}