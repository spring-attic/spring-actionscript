package org.springextensions.actionscript.cairngorm.business
{
	import flexunit.framework.TestCase;
	
	import org.springextensions.actionscript.cairngorm.mocks.MockResponder;

	public class AbstractBusinessDelegateTest extends TestCase {
		
		public function AbstractBusinessDelegateTest(methodName:String=null) {
			super(methodName);
		}
		
		public function testParameterlessConstructor():void {
			var abd:AbstractBusinessDelegate = new AbstractBusinessDelegate();
			assertNull(abd.responder);
			assertNull(abd.service);
		}
		
		public function testParameterizedConstructor():void {
			var mockService:Object = {};
			var mockResponder:MockResponder = new MockResponder();
			var abd:AbstractBusinessDelegate = new AbstractBusinessDelegate(mockService, mockResponder);
			assertEquals(abd.responder,mockResponder);
			assertEquals(abd.service, mockService);
		}

	}
}