package org.springextensions.actionscript.domain.util {

	import flexunit.framework.TestCase;

	import org.springextensions.actionscript.domain.INamed;

	/**
	 * @author Christophe Herreman
	 */
	public class NamedUtilTest extends TestCase {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function NamedUtilTest() {
			super();
		}

		// --------------------------------------------------------------------
		//
		// Tests - getSuffixIndex
		//
		// --------------------------------------------------------------------

		public function testGetSuffixIndex():void {
			assertEquals(-1, NamedUtil.getSuffixIndex("test"));
			assertEquals(5, NamedUtil.getSuffixIndex("test (1)"));
			assertEquals(7, NamedUtil.getSuffixIndex("  test (1)"));
			assertEquals(7, NamedUtil.getSuffixIndex("  test (1)  "));
			assertEquals(5, NamedUtil.getSuffixIndex("test (123)"));
		}

		// --------------------------------------------------------------------
		//
		// Tests - getBaseName
		//
		// --------------------------------------------------------------------

		public function testGetBaseName():void {
			assertEquals("test", NamedUtil.getBaseName("test"));
			assertEquals("test", NamedUtil.getBaseName("test (1)"));
			assertEquals("test", NamedUtil.getBaseName("  test (1)"));
			assertEquals("test", NamedUtil.getBaseName("  test (1)  "));
			assertEquals("test", NamedUtil.getBaseName("test (123)"));
		}

		// --------------------------------------------------------------------
		//
		// Tests - createUniqueName
		//
		// --------------------------------------------------------------------

		public function testCreateUniqueName():void {
			var named1:INamed = new NamedImpl("A name");
			var named2:INamed = new NamedImpl("Another name");
			var named3:INamed = new NamedImpl("Another name (2)");
			var named4:INamed = new NamedImpl("Another name (4)");

			var namedObjects:Array = [named1, named2, named3, named4];

			assertEquals("Non existing name", NamedUtil.createUniqueName("Non existing name", namedObjects));
			assertEquals("A name (2)", NamedUtil.createUniqueName("A name", namedObjects));
			assertEquals("Another name (3)", NamedUtil.createUniqueName("Another name", namedObjects));
			assertEquals("Another name (3)", NamedUtil.createUniqueName("Another name (2)", namedObjects));
		}

		public function testCreateUniqueName2():void {
			var named1:INamed = new NamedImpl("A name (2)");
			var namedObjects:Array = [named1];

			assertEquals("A name", NamedUtil.createUniqueName("A name (2)", namedObjects));
		}

	}
}