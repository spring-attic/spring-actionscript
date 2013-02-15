package org.springextensions.actionscript.core.operation {

	import flash.utils.setTimeout;

	import flexunit.framework.TestCase;

	/**
	 * @author Christophe Herreman
	 */
	public class AbstractOperationTest extends TestCase {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function AbstractOperationTest() {
			super();
		}

		// --------------------------------------------------------------------
		//
		// Test
		//
		// --------------------------------------------------------------------

		public function testNew_shouldAllowNoArgs():void {
			var operation:IOperation = new AbstractOperation();
			assertNotNull(operation);
		}

		// --------------------------------------------------------------------
		//
		// Test
		//
		// --------------------------------------------------------------------

		public function testNew_shouldTimeoutAfterOneSecondAndBlockCompleteAndErrorEvent():void {
			var operation:IOperation = new AbstractOperation(1000);
			operation.addCompleteListener(testNew_shouldTimeoutAfterOneSecond_completeHandler);
			operation.addErrorListener(testNew_shouldTimeoutAfterOneSecond_errorHandler);
			operation.addTimeoutListener(addAsync(testNew_shouldTimeoutAfterOneSecond_timeoutHandler, 2000, null, testNew_shouldTimeoutAfterOneSecond_asyncFailHandler));
		}

		private function testNew_shouldTimeoutAfterOneSecond_completeHandler(event:OperationEvent):void {
			fail("Complete event should not be dispatched");
		}

		private function testNew_shouldTimeoutAfterOneSecond_errorHandler(event:OperationEvent):void {
			fail("Error event should not be dispatched");
		}

		private function testNew_shouldTimeoutAfterOneSecond_timeoutHandler(event:OperationEvent):void {
			assertNull(event.result);
			assertNull(event.error);

			// now that the operation timed out, try to dispatch a complete and error event
			// both should NOT be dispatched
			var operation:AbstractOperation = AbstractOperation(event.operation);
			var completeEventDispatched:Boolean = operation.dispatchCompleteEvent();
			var errorEventDispatched:Boolean = operation.dispatchErrorEvent();

			assertFalse(completeEventDispatched);
			assertFalse(errorEventDispatched);
		}

		private function testNew_shouldTimeoutAfterOneSecond_asyncFailHandler(arg:Object = null):void {
			fail("Operation should have timed out after 1000 milliseconds");
		}

		// --------------------------------------------------------------------
		//
		// Test
		//
		// --------------------------------------------------------------------

		public function testNew_shouldNotAutoStart():void {
			var operation:IOperation = new AbstractOperation(1000, false);
			operation.addCompleteListener(testNew_shouldNotAutoStart_completeHandler);
			operation.addErrorListener(testNew_shouldNotAutoStart_errorHandler);
			operation.addTimeoutListener(addAsync(testNew_shouldNotAutoStart_timeoutHandler, 2000, operation, testNew_shouldNotAutoStart_asyncFailHandler));
		}

		private function testNew_shouldNotAutoStart_completeHandler(event:OperationEvent):void {
			// nothing here, just handle the event
		}

		private function testNew_shouldNotAutoStart_errorHandler(event:OperationEvent):void {
			// nothing here, just handle the event
		}

		private function testNew_shouldNotAutoStart_timeoutHandler(event:OperationEvent):void {
			fail("Timeout event should not be dispatched since autostart is set to false");
		}

		private function testNew_shouldNotAutoStart_asyncFailHandler(operation:IOperation):void {
			// the timeout event was not dispatched as we expected
			// now  try to dispatch a complete and error event
			// both should be dispatched
			var completeEventDispatched:Boolean = AbstractOperation(operation).dispatchCompleteEvent();
			var errorEventDispatched:Boolean = AbstractOperation(operation).dispatchErrorEvent();

			assertTrue(completeEventDispatched);
			assertTrue(errorEventDispatched);
		}

		// --------------------------------------------------------------------
		//
		// Test
		//
		// --------------------------------------------------------------------

		public function testNew_shouldNotTimeoutWhenCompleteEventIsDispatched():void {
			var operation:AbstractOperation = new AbstractOperation(1000);
			operation.addCompleteListener(testNew_shouldNotTimeoutWhenCompleteEventIsDispatched_completeHandler);
			operation.addErrorListener(testNew_shouldNotTimeoutWhenCompleteEventIsDispatched_errorHandler);
			operation.addTimeoutListener(addAsync(testNew_shouldNotTimeoutWhenCompleteEventIsDispatched_timeoutHandler, 2000, operation, testNew_shouldNotTimeoutWhenCompleteEventIsDispatched_asyncFailHandler));

			// dispatch a complete event before the timeout is reached
			var dispatchCompleteEvent:Function = function():void {
				operation.dispatchCompleteEvent();
			};

			setTimeout(dispatchCompleteEvent, 500);
		}

		private function testNew_shouldNotTimeoutWhenCompleteEventIsDispatched_completeHandler(event:OperationEvent):void {
			// nothing here, just handle the event
		}

		private function testNew_shouldNotTimeoutWhenCompleteEventIsDispatched_errorHandler(event:OperationEvent):void {
			fail("Error event should not be dispatched");
		}

		private function testNew_shouldNotTimeoutWhenCompleteEventIsDispatched_timeoutHandler(event:OperationEvent):void {
			fail("Timeout event should not be dispatched since complete event was dispatched");
		}

		private function testNew_shouldNotTimeoutWhenCompleteEventIsDispatched_asyncFailHandler(operation:IOperation):void {
			// ok if we get here since timeout event was not dispatched
		}

		// --------------------------------------------------------------------
		//
		// Test
		//
		// --------------------------------------------------------------------

		public function testNew_shouldNotTimeoutWhenErrorEventIsDispatched():void {
			var operation:AbstractOperation = new AbstractOperation(1000);
			operation.addCompleteListener(testNew_shouldNotTimeoutWhenErrorEventIsDispatched_completeHandler);
			operation.addErrorListener(testNew_shouldNotTimeoutWhenErrorEventIsDispatched_errorHandler);
			operation.addTimeoutListener(addAsync(testNew_shouldNotTimeoutWhenErrorEventIsDispatched_timeoutHandler, 2000, operation, testNew_shouldNotTimeoutWhenErrorEventIsDispatched_asyncFailHandler));

			// dispatch a complete event before the timeout is reached
			var dispatchCompleteEvent:Function = function():void {
				operation.dispatchCompleteEvent();
			};

			setTimeout(dispatchCompleteEvent, 500);
		}

		private function testNew_shouldNotTimeoutWhenErrorEventIsDispatched_completeHandler(event:OperationEvent):void {
			// nothing here, just handle the event
		}

		private function testNew_shouldNotTimeoutWhenErrorEventIsDispatched_errorHandler(event:OperationEvent):void {
			fail("Error event should not be dispatched");
		}

		private function testNew_shouldNotTimeoutWhenErrorEventIsDispatched_timeoutHandler(event:OperationEvent):void {
			fail("Timeout event should not be dispatched since complete event was dispatched");
		}

		private function testNew_shouldNotTimeoutWhenErrorEventIsDispatched_asyncFailHandler(operation:IOperation):void {
			// ok if we get here since timeout event was not dispatched
		}

	}
}