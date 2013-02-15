package org.springextensions.actionscript.ioc.factory.config.testclasses {

	public class AnnotatedEventHandlers {

		public static const EVENT_ONE:String = "eventOne";

		private var _numMethodOneInvocations:uint;
		private var _numMethodOneHandlerInvocations:uint;
		private var _numMethodTwoInvocations:uint;
		private var _numMethodThreeInvocations:uint;

		public function AnnotatedEventHandlers() {
		}

		public function get numMethodOneInvocations():uint {
			return _numMethodOneInvocations;
		}

		public function get numMethodOneHandlerInvocations():uint {
			return _numMethodOneHandlerInvocations;
		}

		public function get numMethodTwoInvocations():uint {
			return _numMethodTwoInvocations;
		}

		public function get numMethodThreeInvocations():uint {
			return _numMethodThreeInvocations;
		}

		[EventHandler]
		public function eventOne():void {
			_numMethodOneInvocations++;
		}

		[EventHandler]
		public function eventOneHandler():void {
			_numMethodOneHandlerInvocations++;
		}

		[EventHandler(name="eventOne")]
		public function methodTwo():void {
			_numMethodTwoInvocations++;
		}

		[EventHandler("eventOne")]
		public function methodThree():void {
			_numMethodThreeInvocations++;
		}
	}
}