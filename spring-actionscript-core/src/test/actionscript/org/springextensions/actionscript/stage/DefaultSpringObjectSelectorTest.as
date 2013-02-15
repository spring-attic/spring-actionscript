package org.springextensions.actionscript.stage {
	import flash.utils.getTimer;

	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	public class DefaultSpringObjectSelectorTest {

		private static var m_selector:DefaultSpringObjectSelector = new DefaultSpringObjectSelector();

		public function DefaultSpringObjectSelectorTest() {
		}

		[Test]
		public function testApproveClassName():void {
			assertRejected("mx.subpackage.Class");
			assertRejected("spark.subpackage.Class");
			assertRejected("flash.subpackage.Class");
			assertRejected("__embed");
			assertRejected("_skin");
			assertRejected("_icon");

			assertApproved("com.company");
			assertApproved("org.company");
			assertApproved("main");
			assertApproved("Main");
		}

		[Test]
		public function testApproveClassName_speed():void {
			var t:Number = getTimer();
			for (var i:uint = 0; i < 10000; i++) {
				testApproveClassName();
			}
			var t2:Number = getTimer() - t;
			trace("DefaultSpringObjectSelectorTest.testApproveClassName_speed - " + t2 + "ms");
		}

		// --------------------------------------------------------------------
		//
		// Assertions
		//
		// --------------------------------------------------------------------

		private static function assertApproved(className:String):void {
			assertTrue(m_selector.approveClassName(className));
		}

		private static function assertRejected(className:String):void {
			assertFalse(m_selector.approveClassName(className));
		}
	}
}
