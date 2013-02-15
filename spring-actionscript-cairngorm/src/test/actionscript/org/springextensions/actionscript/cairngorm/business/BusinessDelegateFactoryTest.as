package org.springextensions.actionscript.cairngorm.business
{
	import flexunit.framework.TestCase;
	
	import org.springextensions.actionscript.cairngorm.mocks.MockDelegate;
	import org.springextensions.actionscript.cairngorm.mocks.MockResponder;

	public class BusinessDelegateFactoryTest extends TestCase {
		
		public function BusinessDelegateFactoryTest(methodName:String=null) {
			super(methodName);
		}
		
		public function testCreateBusinessDelegate():void {
			var mockResponder:MockResponder = new MockResponder();
			var mockservice:Object = {};
			var bdf:BusinessDelegateFactory = new BusinessDelegateFactory();
			bdf.responder = mockResponder;
			bdf.service = mockservice;
			bdf.delegateClass = MockDelegate;
			var bd:MockDelegate = bdf.createBusinessDelegate() as MockDelegate;
			
			assertNotNull(bd);
			assertEquals(bd.responder,mockResponder);
			assertEquals(bd.service,mockservice);
		}
		
		public function testDelegateClassMustImplementIBusinessDelegate():void {
			var bdf:BusinessDelegateFactory = new BusinessDelegateFactory();
			try
			{
				bdf.delegateClass = TestCase;
				fail("BusinessDelegateFactory must not accept delegate classes that don't implement IBusinessDelegate");
			}
			catch(e:*){
				
			}
		}
	}
}